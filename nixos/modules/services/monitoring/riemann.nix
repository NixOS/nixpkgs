{
  config,
  pkgs,
  lib,
  ...
}:
let

  cfg = config.services.riemann;

  classpath = lib.concatStringsSep ":" (
    cfg.extraClasspathEntries ++ [ "${pkgs.riemann}/share/java/riemann.jar" ]
  );

  riemannConfig = lib.concatStringsSep "\n" (
    [ cfg.config ] ++ (map (f: ''(load-file "${f}")'') cfg.configFiles)
  );

  launcher = pkgs.writeScriptBin "riemann" ''
    #!/bin/sh
    exec ${pkgs.jdk}/bin/java ${lib.concatStringsSep " " cfg.extraJavaOpts} \
      -cp ${classpath} \
      riemann.bin ${cfg.configFile}
  '';

in
{

  options = {

    services.riemann = {
      enable = lib.mkEnableOption "Riemann network monitoring daemon";

      config = lib.mkOption {
        type = lib.types.lines;
        description = ''
          Contents of the Riemann configuration file. For more complicated
          config you should use configFile.
        '';
      };
      configFiles = lib.mkOption {
        type = with lib.types; listOf path;
        default = [ ];
        description = ''
          Extra files containing Riemann configuration. These files will be
          loaded at runtime by Riemann (with Clojure's
          `load-file` function) at the end of the
          configuration if you use the config option, this is ignored if you
          use configFile.
        '';
      };
      configFile = lib.mkOption {
        type = lib.types.str;
        description = ''
          A Riemann config file. Any files in the same directory as this file
          will be added to the classpath by Riemann.
        '';
      };
      extraClasspathEntries = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description = ''
          Extra entries added to the Java classpath when running Riemann.
        '';
      };
      extraJavaOpts = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description = ''
          Extra Java options used when launching Riemann.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    users.groups.riemann.gid = config.ids.gids.riemann;

    users.users.riemann = {
      description = "riemann daemon user";
      uid = config.ids.uids.riemann;
      group = "riemann";
    };

    services.riemann.configFile = lib.mkDefault (pkgs.writeText "riemann-config.clj" riemannConfig);

    systemd.services.riemann = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.inetutils ];
      serviceConfig = {
        User = "riemann";
        ExecStart = "${launcher}/bin/riemann";
      };
      serviceConfig.LimitNOFILE = 65536;
    };

  };

}
