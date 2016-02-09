{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.winstone;

  winstoneOpts = { name, ... }: {
    options = {
      name = mkOption {
        default = name;
        internal = true;
      };

      serviceName = mkOption {
        type = types.str;
        description = ''
          The name of the systemd service. By default, it is
          derived from the winstone instance name.
        '';
      };

      warFile = mkOption {
        type = types.str;
        description = ''
          The WAR file that Winstone should serve.
        '';
      };

      javaPackage = mkOption {
        type = types.package;
        default = pkgs.jre;
        defaultText = "pkgs.jre";
        description = ''
          Which Java derivation to use for running Winstone.
        '';
      };

      user = mkOption {
        type = types.str;
        description = ''
          The user that should run this Winstone process and
          own the working directory.
        '';
      };

      group = mkOption {
        type = types.str;
        description = ''
          The group that will own the working directory.
        '';
      };

      workDir = mkOption {
        type = types.str;
        description = ''
          The working directory for this Winstone instance. Will
          contain extracted webapps etc. The directory will be
          created if it doesn't exist.
        '';
      };

      extraJavaOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra command line options given to the java process running
          Winstone.
        '';
      };

      extraOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra command line options given to the Winstone process.
        '';
      };
    };

    config = {
      workDir = mkDefault "/run/winstone/${name}";
      serviceName = mkDefault "winstone-${name}";
    };
  };

  mkService = cfg: let
    opts = concatStringsSep " " (cfg.extraOptions ++ [
      "--warfile ${cfg.warFile}"
    ]);

    javaOpts = concatStringsSep " " (cfg.extraJavaOptions ++ [
      "-Djava.io.tmpdir=${cfg.workDir}"
      "-jar ${pkgs.winstone}/lib/winstone.jar"
    ]);
  in {
    wantedBy = [ "multi-user.target" ];
    description = "winstone service for ${cfg.name}";
    preStart = ''
      mkdir -p "${cfg.workDir}"
      chown ${cfg.user}:${cfg.group} "${cfg.workDir}"
    '';
    serviceConfig = {
      ExecStart = "${cfg.javaPackage}/bin/java ${javaOpts} ${opts}";
      User = cfg.user;
      PermissionsStartOnly = true;
    };
  };

in {

  options = {
    services.winstone = mkOption {
      default = {};
      type = types.attrsOf types.optionSet;
      options = [ winstoneOpts ];
      description = ''
        Defines independent Winstone services, each serving one WAR-file.
      '';
    };
  };

  config = mkIf (cfg != {}) {

    systemd.services = mapAttrs' (n: c: nameValuePair c.serviceName (mkService c)) cfg;

  };

}
