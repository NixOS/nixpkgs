{ pkgs, lib, runit, mainConfig }:

with lib;
let bin = lib.getBin runit;

    makeLogConfig = name: config:
      pkgs.writeText "log-config-${name}" ''
        ${optionalString (config.maxFileSize != null)
           "s${builtins.toString config.maxFileSize}"}
        ${optionalString (config.maxAge != null)
           "t${builtins.toString config.maxAge}"}
        ${optionalString (config.maxKeeparound == null)
           "n0"}
        ${optionalString (config.maxKeeparound != null)
           "n${builtins.toString config.maxKeeparound}"}
        N${builtins.toString config.minKeeparound}
        ${optionalString (config.processor != null)
           "!${pkgs.writeScript config.processor}"}
      ''; # Todo, prefixes, patterns

    ioniceCmd = config:
        "${lib.getBin pkgs.utillinux}/bin/ionice " +
	 lib.optionalString (config.ioSchedulingClass != null)
	   "-c ${config.ioSchedulingClass} " +
	 lib.optionalString (config.ioPriority != null)
	   "-n ${builtins.toString config.ioPriority}";

    chpstCmd = config:
      let user = concatStringsSep ":" ([ config.user ] ++ config.groups);
      in lib.concatStringsSep " " [
        (optionalString (config.ioPriority != null || config.ioSchedulingClass != null)
	  (ioniceCmd config))
        "${bin}/bin/chpst"
        (optionalString (config.user != null) "-u ${user} -U ${user}")
	(optionalString (config.nice != null) "-n ${builtins.toString config.nice}")
	(optionalString (config.limits.nofiles != null)
	  "-o ${builtins.toString config.limits.nofiles}")
      ];

    loggingOpts = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable runit logging";
      };

      redirectStderr = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to redirect stderr to stdout";
      };

      logDirectory = mkOption {
        type = types.string;
        description = "Where to store log files";
        defaultText = "/var/log/<name>/";
      };

      processor = mkOption {
        type = types.nullOr types.string;
        description = "Log processing script";
        default = null;
      };

      minKeeparound = mkOption {
        type = types.int;
        description = "The minimum number of logs to keep around";
        default = 3;
      };

      maxKeeparound = mkOption {
        type = types.nullOr types.int;
        description = "The maximum number of logs to keep around";
        default = 5;
      };

      maxFileSize = mkOption {
        type = types.nullOr types.int;
        description = "The maximum file size (in bytes) of logs before rotation";
        default = null;
      };

      maxAge = mkOption {
        type = types.nullOr types.int;
        description = "The maximum amount of time before rotation (in seconds)";
        default = null;
      };

      logScript = mkOption {
        type = types.nullOr types.string;
        description = "A custom logging script. Overrides all other settings";
        default = null;
      };
    };

    waitForSoftDep = dep: ''
    if [ -d "/run/current-services/${dep}" ]; then
      deps+=" /run/current-services/${dep}"
    fi
    '';

    waitForDependencies = timeout: deps: softDeps: ''
       deps="${concatStringsSep " " (map (dep: "/run/current-services/${dep}") deps)}"
       ${concatStringsSep "\n" (map waitForSoftDep softDeps)}
       ${optionalString (builtins.length softDeps > 0 && builtins.length deps == 0)
         "if [ ! -z \"$deps\" ]; then"}
       ${optionalString (builtins.length deps > 0 || builtins.length softDeps > 0)
          "${bin}/bin/sv -w ${builtins.toString timeout} start $deps"}
       ${optionalString (builtins.length softDeps > 0 && builtins.length deps == 0)
         "fi"}
     '';

    mkScript = script: ''
      #!${pkgs.runtimeShell} -e
      ${script}
    '';

    makeServiceDir = name: config:
      pkgs.runCommand name
        { inherit (config) runScript finishScript;
          inherit (config.logging) logScript;

          checkScript =
            if builtins.isNull config.check then null
            else ''
              #!${pkgs.runtimeShell} -e
              ${config.check}
            '';

          passAsFile = [ "runScript" "checkScript" "finishScript" "logScript" ];
          preferLocalBuild = true;
          allowSubstitutes = false;
          enableLogging = config.logging.enable;
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
            mv "$finishScriptPath" "$out/finish"
            chmod +x "$out/finish"
          fi

          if [ -n "$enableLogging" ] && [ -n "$logScriptPath" ]; then
            mkdir -p "$out/log"
            mv "$logScriptPath" "$out/log/run"
            chmod +x "$out/log/run"
            ln -s /var/run/runit/sv.log.${name} "$out/log/supervise"
          fi

          ln -s /var/run/runit/sv.${name} "$out/supervise"
        '';
in {

  checkService = services: name: { requires, user, ... }:
    concatMap (reqName: [
      { assertion = builtins.hasAttr reqName services;
        message = "The runit service ${name} depends on an unknown service: ${reqName}"; }

      { assertion = !(builtins.hasAttr reqName services) || services."${reqName}".enable;
        message = "The runit service ${name} depends on ${reqName}, but it is marked as disabled"; }

      { assertion = (user != null) -> (builtins.hasAttr user mainConfig.users.users);
        message = "The runit service ${name} is requesting to run as ${user}, but this username does not exist"; }
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

      softRequires = mkOption {
        default = [];
        type = types.listOf types.str;
        description = ''
          Units that should be started before we start, if they exist
        '';
      };

      nice = mkOption {
        default = null;
	type = types.nullOr types.int;
	description = ''
	  Nice adjustment
	'';
      };

      ioSchedulingClass = mkOption {
        type = types.nullOr (types.enum [ "none" "realtime" "best-effort" "idle" ]);
	description = ''
	  Linux I/O scheduling class. If a priority is set, defaults
	  to 'best-effort,'.
	'';
      };

      ioPriority = mkOption {
        default = null;
	type = types.nullOr types.int;
	description = ''
	  Linux IO scheduling priority
	'';
      };

      limits = {
        nofiles = mkOption {
	  default = null;
	  type = types.nullOr types.int;
	  description = ''
	    Limit the number of open files
	  '';
	};
      };

      waitTime = mkOption {
        default = 1;
        type = types.int;
        description = ''
          How long to wait for the required units to be up before starting
        '';
      };

      path = mkOption {
        apply = ps: "${makeBinPath ps}:${makeSearchPathOutput "bin" "sbin" ps}";
        description = ''
          Packages added to the service's <envar>PATH</envar>
          environment variable.  Both the <filename>bin</filename>
          and <filename>sbin</filename> subdirectories of each
          package are added.
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

      user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The user to run this daemon as";
      };

      groups = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Groups to run this daemon as";
      };

      oneshot = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If true, the service should only be brought up once, unless explicitly reloaded.

          This creates a file /var/run/runit/<service-name>.oneshot, and then waits for the file
          (using inotifywait).

          If the service is reloaded and the file exists, then nothing happens. Otherwise, if the
          file is deleted, the service will automatically restart.
        '';
      };

      check = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Runit check command";
      };

      logging = loggingOpts;

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

      oomScoreAdj = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          Optional value to set in /proc/self/oom_score_adj
        '';
      };
    };

    config = {
      name = mkDefault name;
      path = [ pkgs.coreutils ];
      ioSchedulingClass = mkDefault (if config.ioPriority != null then "best-effort" else null);
      runScript = mkDefault ''
        #!${pkgs.runtimeShell} -e

        ${waitForDependencies config.waitTime config.requires config.softRequires}
        >&2 echo "[ init ] starting ${config.name}"

        ${lib.optionalString config.oneshot ''
          oneshot_status="/var/run/runit/${config.name}.oneshot"
          if [ ! -f "$oneshot_status" ]; then
            >&2 echo "[ init ] launching ${config.name} once"
          ''}

        ${lib.optionalString (config.oomScoreAdj != null) "echo '${builtins.toString config.oomScoreAdj}' > /proc/self/oom_score_adj || echo 'Failed to adjust oom score'"}

        ${lib.optionalString (!config.oneshot) "exec \\"}
        ${pkgs.coreutils}/bin/env -C "/run/current-services/${config.name}" \
        ${lib.concatStringsSep "\\\n"
            (lib.mapAttrsToList (name: val: "  ${name}=\"${val}\" ") config.environment)}\
           ${chpstCmd config} \
           ${pkgs.writeScript "runit-service" (mkScript config.script)} \
           ${lib.optionalString config.logging.redirectStderr "2>&1"}

        ${lib.optionalString config.oneshot "fi"}

        ${lib.optionalString config.oneshot ''
          if [ $? -eq 0 ]; then
            >&2 echo "[ init ] noting ${config.name} as complete"
            touch "$oneshot_status"
            exec ${pkgs.inotifyTools}/bin/inotifywait -e delete "$oneshot_status"
          fi
          ''}
      '';

      finishScript = mkIf (config.stop != null || config.oneshot) ''
        #!${pkgs.runtimeShell} -e

        ${lib.optionalString (config.stop != null) "${pkgs.writeScript "runit-stop" (mkScript config.stop)} $1 $2"}
      '';

      environment.PATH = config.path;

      logging = {
        logDirectory = mkDefault "/var/log/${name}";

        logScript = mkDefault ''
          #!${pkgs.runtimeShell} -e
          mkdir -p ${config.logging.logDirectory}
          if [ -e "${config.logging.logDirectory}/config" ]; then
            rm "${config.logging.logDirectory}/config"
          fi
          ln -s ${makeLogConfig config.name config.logging} "${config.logging.logDirectory}/config"
          exec ${bin}/bin/svlogd -tt ${config.logging.logDirectory}
        '';
      };
    };
  };
}
