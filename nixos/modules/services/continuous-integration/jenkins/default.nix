{ config, pkgs, ... }:
with pkgs.lib;
let
  cfg = config.services.jenkins;
  userCfg = config.users.jenkins;
in {
  options = {
    services.jenkins = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the jenkins continuous integration server.
        '';
      };

      user = mkOption {
        default = "jenkins";
        type = with types; string;
        description = ''
          User the jenkins server should execute under. Defaults to the "jenkins" user.
        '';
      };

      home = mkOption {
        default = userCfg.home;
        type = with types; string;
        description = ''
          The path to use as JENKINS_HOME. Defaults to the home of the "jenkins" user.
        '';
      };

      port = mkOption {
        default = 8080;
        type = types.uniq types.int;
        description = ''
          Specifies port number on which the jenkins HTTP interface listens. The default is 8080
        '';
      };

      packages = mkOption {
        default = [ pkgs.stdenv pkgs.git pkgs.jdk pkgs.openssh pkgs.nix ];
        type = types.listOf types.package;
        description = ''
          Packages to add to PATH for the jenkins process.
        '';
      };

      environment = mkOption {
        default = { NIX_REMOTE = "daemon"; };
        type = with types; attrsOf string;
        description = ''
          Additional environment variables to be passed to the jenkins process.
          The environment will always include JENKINS_HOME.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.jenkins.enable = true;

    systemd.services.jenkins = {
      description = "jenkins continuous integration server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        JENKINS_HOME = cfg.home;
      } // cfg.environment;

      path = cfg.packages;

      script = ''
        ${pkgs.jdk}/bin/java -jar ${pkgs.jenkins} --httpPort=${toString cfg.port}
      '';

      postStart = ''
        until ${pkgs.curl}/bin/curl -L localhost:${toString cfg.port} ; do
          sleep 10
        done
        while true ; do
          index=`${pkgs.curl}/bin/curl -L localhost:${toString cfg.port}`
          if [[ !("$index" =~ 'Please wait while Jenkins is restarting' ||
                  "$index" =~ 'Please wait while Jenkins is getting ready to work') ]]; then
            exit 0
          fi
          sleep 30
        done
      '';

      serviceConfig = {
        User = cfg.user;
      };
    };
  };
}
