{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.jboss;

  jbossService = pkgs.stdenv.mkDerivation {
    name = "jboss-server";
    builder = ./builder.sh;
    inherit (pkgs) jboss su;
    inherit (cfg)
      tempDir
      logDir
      libUrl
      deployDir
      serverDir
      user
      useJK
      ;
  };

in

{

  ###### interface

  options = {

    services.jboss = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable JBoss. WARNING : this package is outdated and is known to have vulnerabilities.";
      };

      tempDir = lib.mkOption {
        default = "/tmp";
        type = lib.types.str;
        description = "Location where JBoss stores its temp files";
      };

      logDir = lib.mkOption {
        default = "/var/log/jboss";
        type = lib.types.str;
        description = "Location of the logfile directory of JBoss";
      };

      serverDir = lib.mkOption {
        description = "Location of the server instance files";
        default = "/var/jboss/server";
        type = lib.types.str;
      };

      deployDir = lib.mkOption {
        description = "Location of the deployment files";
        default = "/nix/var/nix/profiles/default/server/default/deploy/";
        type = lib.types.str;
      };

      libUrl = lib.mkOption {
        default = "file:///nix/var/nix/profiles/default/server/default/lib";
        description = "Location where the shared library JARs are stored";
        type = lib.types.str;
      };

      user = lib.mkOption {
        default = "nobody";
        description = "User account under which jboss runs.";
        type = lib.types.str;
      };

      useJK = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use to connector to the Apache HTTP server";
      };

    };

  };

  ###### implementation

  config = lib.mkIf config.services.jboss.enable {
    systemd.services.jboss = {
      description = "JBoss server";
      script = "${jbossService}/bin/control start";
      wantedBy = [ "multi-user.target" ];
    };
  };
}
