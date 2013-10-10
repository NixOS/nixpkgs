{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.jboss;

  jbossService = pkgs.stdenv.mkDerivation {
    name = "jboss-server";
    builder = ./builder.sh;
    inherit (pkgs) jboss su;
    inherit (cfg) tempDir logDir libUrl deployDir serverDir user useJK;
  };

in

{

  ###### interface

  options = {

    services.jboss = {

      enable = mkOption {
        default = false;
        description = "Whether to enable jboss";
      };

      tempDir = mkOption {
        default = "/tmp";
        description = "Location where JBoss stores its temp files";
      };

      logDir = mkOption {
        default = "/var/log/jboss";
        description = "Location of the logfile directory of JBoss";
      };

      serverDir = mkOption {
        description = "Location of the server instance files";
        default = "/var/jboss/server";
      };

      deployDir = mkOption {
        description = "Location of the deployment files";
        default = "/nix/var/nix/profiles/default/server/default/deploy/";
      };

      libUrl = mkOption {
        default = "file:///nix/var/nix/profiles/default/server/default/lib";
        description = "Location where the shared library JARs are stored";
      };

      user = mkOption {
        default = "nobody";
        description = "User account under which jboss runs.";
      };

      useJK = mkOption {
        default = false;
        description = "Whether to use to connector to the Apache HTTP server";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.jboss.enable {

    jobs.jboss =
      { description = "JBoss server";

        exec = "${jbossService}/bin/control start";
      };

  };

}
