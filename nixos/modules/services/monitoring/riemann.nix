{ config, pkgs, lib, ... }:

with pkgs;
with lib;

let

  cfg = config.services.riemann;

  classpath = concatStringsSep ":" (
    cfg.extraClasspathEntries ++ [ "${riemann}/share/java/riemann.jar" ]
  );

  launcher = writeScriptBin "riemann" ''
    #!/bin/sh
    exec ${openjdk}/bin/java ${concatStringsSep "\n" cfg.extraJavaOpts} \
      -cp ${classpath} \
      riemann.bin ${writeText "riemann.config" cfg.config}
  '';

in {

  options = {

    services.riemann = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the Riemann network monitoring daemon.
        '';
      };
      config = mkOption {
        type = types.lines;
        description = ''
          Contents of the Riemann configuration file.
        '';
      };
      extraClasspathEntries = mkOption {
        type = with types; listOf str;
        default = [];
        description = ''
          Extra entries added to the Java classpath when running Riemann.
        '';
      };
      extraJavaOpts = mkOption {
        type = with types; listOf str;
        default = [];
        description = ''
          Extra Java options used when launching Riemann.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    users.extraGroups.riemann.gid = config.ids.gids.riemann;

    users.extraUsers.riemann = {
      description = "riemann daemon user";
      uid = config.ids.uids.riemann;
      group = "riemann";
    };

    systemd.services.riemann = {
      wantedBy = [ "multi-user.target" ];
      path = [ inetutils ];
      serviceConfig = {
        User = "riemann";
        ExecStart = "${launcher}/bin/riemann";
      };
    };

  };

}
