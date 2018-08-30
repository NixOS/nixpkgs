{ config, pkgs, lib, ... }:

with pkgs;
with lib;

let

  cfg = config.services.riemann;

  classpath = concatStringsSep ":" (
    cfg.extraClasspathEntries ++ [ "${riemann}/share/java/riemann.jar" ]
  );

  riemannConfig = concatStringsSep "\n" (
    [cfg.config] ++ (map (f: ''(load-file "${f}")'') cfg.configFiles)
  );

  launcher = writeScriptBin "riemann" ''
    #!/bin/sh
    exec ${jdk}/bin/java ${concatStringsSep "\n" cfg.extraJavaOpts} \
      -cp ${classpath} \
      riemann.bin ${writeText "riemann-config.clj" riemannConfig}
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
      configFiles = mkOption {
        type = with types; listOf path;
        default = [];
        description = ''
          Extra files containing Riemann configuration. These files will be
          loaded at runtime by Riemann (with Clojure's
          <literal>load-file</literal> function) at the end of the
          configuration.
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

    users.groups.riemann.gid = config.ids.gids.riemann;

    users.users.riemann = {
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
