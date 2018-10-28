{ pkgs, lib, runit }:

with lib;
let bin = lib.getBin runit;

    waitForDependencies = timeout: deps: ''
       ${optionalString (builtins.length deps > 0)
          "${bin}/bin/sv start -w ${builtins.toString timeout} ${concatStringsSep " " (map (dep: "/etc/sv/${dep}") deps)}"}
     '';

    makeServiceDir = name: config:
      pkgs.runCommand name
        { inherit (config) runScript finishScript;

          checkScript =
            if builtins.isNull config.check then null
            else ''
              #!${pkgs.runtimeShell} -e
              ${config.check}
            '';

          passAsFile = [ "runScript" "checkScript" "finishScript" ];
          preferLocalBuild = true;
          allowSubstitutes = false;
        }
        ''
          mkdir -p "$out"
          mv "$runScriptPath" "$out/run"
          chmod +x "$out/run"

          if [ -n "$checkScriptPath" ]; then
            mv "$checkScriptPath" "$out/check"
            chmod +x "$out/check"
          fi

          if [ -n "$finishScriptPath" ]; then
            mv "$finishScriptPath" "$out/check"
            chmod +x "$out/check"
          fi

          ln -s /var/run/runit/sv.${name} $out/supervise
        '';
in {

  checkService = services: name: { requires, ... }:
    concatMap (reqName: [
      { assertion = builtins.hasAttr reqName services;
        message = "The runit service ${name} depends on an unknown service: ${reqName}"; }

      { assertion = !(builtins.hasAttr reqName services) || services."${reqName}".enable;
        message = "The runit service ${name} depends on ${reqName}, but it is marked as disabled"; }
    ]) requires;

  makeService = name: config:
    { name = "sv/${name}";
      value = { source = makeServiceDir name config; }; };

  serviceConfig = {name, config, ...}: {
    options = {
      name = mkOption {
        type = types.string;
        description = "Service name";
        internal = true;
      };

      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable this service";
      };

      requires = mkOption {
        default = [];
        type = types.listOf types.str;
        description = ''
          Units that we require to be up before we start
        '';
      };

      waitTime = mkOption {
        default = 1;
        type = types.int;
        description = ''
          How long to wait for the required units to be up before starting
        '';
      };

      script = mkOption {
        type = types.str;
        default = "";
        description = "Shell commands executed as the service's main process";
      };

      stop = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Shell commands to run when the service process exits";
      };

      oneshot = mkOption {
        type = types.bool;
        default = false;
        description = "If true, bring the service down if it completes successfully";
      };

      check = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Runit check command";
      };

      logging = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable logging for this service";
      };

      environment = mkOption {
        type = with types; attrsOf (nullOr (either str (either path package)));
        default = { };
        description = ''
          Environment variables for this runit service
        '';
      };

      runScript = mkOption {
        type = types.string;
        description = ''
          The contents of runit /etc/sv/<unit-name>/run script
        '';
      };

      finishScript = mkOption {
        type = types.nullOr types.string;
        default = null;
        description = ''
          The contents of runit /etc/sv/<unit-name>/finish script, or null if not needed
        '';
      };
    };

    config = {
      name = mkDefault name;
      runScript = mkDefault ''
        #!${pkgs.runtimeShell} -e
        ${waitForDependencies config.waitTime config.requires}
        echo "[ init ] starting ${config.name}"
        ${pkgs.coreutils}/bin/env -c "/etc/sv/${config.name}" \
           ${lib.concatStringsSep "\n"
              (lib.mapAttrsToList (name: val: "${name}=\"${val}\"") config.environment)}
           ${pkgs.writeScript "runit-service" config.script}
      '';

      finishScript = mkIf (config.stop != null || config.oneshot) ''
        #!${pkgs.runtimeShell} -e

        ${lib.optionalString (config.stop != null) "${pkgs.writeScript "runit-stop" config.stop} $1 $2"}

        ${lib.optionalString config.oneshot ''
             if [ $1 -eq 0 ]; then
               sv exit ${name}
               ${pkgs.coreutils}/bin/sleep 30
               echo "${name} still running..."
             else
               echo "${name} failed. Waiting 3 seconds to restart"
               ${pkgs.coreutils}/bin/sleep 3
               exit 0
             fi
          ''}
      '';
    };
  };
}
