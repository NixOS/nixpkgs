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
    exec ${jdk}/bin/java ${concatStringsSep " " cfg.extraJavaOpts} \
      -cp ${classpath} \
      riemann.bin ${cfg.configFile}
  '';

in {

  options = {

    services.riemann = {
      enable = mkEnableOption (lib.mdDoc "Riemann network monitoring daemon");

      config = mkOption {
        type = types.lines;
        description = lib.mdDoc ''
          Contents of the Riemann configuration file. For more complicated
          config you should use configFile.
        '';
      };
      configFiles = mkOption {
        type = with types; listOf path;
        default = [];
        description = lib.mdDoc ''
          Extra files containing Riemann configuration. These files will be
          loaded at runtime by Riemann (with Clojure's
          `load-file` function) at the end of the
          configuration if you use the config option, this is ignored if you
          use configFile.
        '';
      };
      configFile = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          A Riemann config file. Any files in the same directory as this file
          will be added to the classpath by Riemann.
        '';
      };
      extraClasspathEntries = mkOption {
        type = with types; listOf str;
        default = [];
        description = lib.mdDoc ''
          Extra entries added to the Java classpath when running Riemann.
        '';
      };
      extraJavaOpts = mkOption {
        type = with types; listOf str;
        default = [];
        description = lib.mdDoc ''
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

    services.riemann.configFile = mkDefault (
      writeText "riemann-config.clj" riemannConfig
    );

    systemd.services.riemann = {
      wantedBy = [ "multi-user.target" ];
      path = [ inetutils ];
      serviceConfig = {
        User = "riemann";
        ExecStart = "${launcher}/bin/riemann";
      };
      serviceConfig.LimitNOFILE = 65536;
    };

  };

}
