{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.jenkins;
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
        type = types.str;
        description = ''
          User the jenkins server should execute under.
        '';
      };

      group = mkOption {
        default = "jenkins";
        type = types.str;
        description = ''
          If the default user "jenkins" is configured then this is the primary
          group of that user.
        '';
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "wheel" "dialout" ];
        description = ''
          List of extra groups that the "jenkins" user should be a part of.
        '';
      };

      home = mkOption {
        default = "/var/lib/jenkins";
        type = types.path;
        description = ''
          The path to use as JENKINS_HOME. If the default user "jenkins" is configured then
          this is the home of the "jenkins" user.
        '';
      };

      port = mkOption {
        default = 8080;
        type = types.uniq types.int;
        description = ''
          Specifies port number on which the jenkins HTTP interface listens. The default is 8080.
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
        type = with types; attrsOf str;
        description = ''
          Additional environment variables to be passed to the jenkins process.
          The environment will always include JENKINS_HOME.
        '';
      };

      extraOptions = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "--debug=9" "--httpListenAddress=localhost" ];
        description = ''
          Additional command line arguments to pass to Jenkins.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraGroups = optional (cfg.group == "jenkins") {
      name = "jenkins";
      gid = config.ids.gids.jenkins;
    };

    users.extraUsers = optional (cfg.user == "jenkins") {
      name = "jenkins";
      description = "jenkins user";
      createHome = true;
      home = cfg.home;
      group = cfg.group;
      extraGroups = cfg.extraGroups;
      useDefaultShell = true;
      uid = config.ids.uids.jenkins;
    };

    systemd.services.jenkins = {
      description = "Jenkins Continuous Integration Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        JENKINS_HOME = cfg.home;
      } // cfg.environment;

      path = cfg.packages;

      script = ''
        ${pkgs.jdk}/bin/java -jar ${pkgs.jenkins} --httpPort=${toString cfg.port} ${concatStringsSep " " cfg.extraOptions}
      '';

      postStart = ''
        until ${pkgs.curl}/bin/curl -s -L localhost:${toString cfg.port} ; do
          sleep 10
        done
        while true ; do
          index=`${pkgs.curl}/bin/curl -s -L localhost:${toString cfg.port}`
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
