{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

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

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable JBoss. WARNING : this package is outdated and is known to have vulnerabilities.";
      };

      tempDir = mkOption {
        default = "/tmp";
        type = types.path;
        description = "Location where JBoss stores its temp files";
      };

      logDir = mkOption {
        default = "/var/log/jboss";
        type = types.path;
        description = "Location of the logfile directory of JBoss";
      };

      serverDir = mkOption {
        description = "Location of the server instance files";
        default = "/var/jboss/server";
        type = types.path;
      };

      deployDir = mkOption {
        description = "Location of the deployment files";
        default = "/nix/var/nix/profiles/default/server/default/deploy/";
        type = types.path;
      };

      libUrl = mkOption {
        default = "file:///nix/var/nix/profiles/default/server/default/lib";
        description = "Location where the shared library JARs are stored";
        type = types.str;
      };

      user = mkOption {
        default = "nobody";
        description = "User account under which jboss runs.";
        type = types.str;
      };

      useJK = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to use to connector to the Apache HTTP server";
      };

    };

  };

  ###### implementation

  config = mkIf config.services.jboss.enable {
    systemd.services.jboss = {
      description = "JBoss server";
      script = "${jbossService}/bin/control start";
      wantedBy = [ "multi-user.target" ];
    };
  };
}
