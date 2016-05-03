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
        type = types.int;
        description = ''
          Specifies port number on which the jenkins HTTP interface listens. The default is 8080.
        '';
      };

      packages = mkOption {
        default = [ pkgs.stdenv pkgs.git pkgs.jdk config.programs.ssh.package pkgs.nix ];
        type = types.listOf types.package;
        description = ''
          Packages to add to PATH for the jenkins process.
        '';
      };

      environment = mkOption {
        default = { };
        type = with types; attrsOf str;
        description = ''
          Additional environment variables to be passed to the jenkins process.
          As a base environment, jenkins receives NIX_PATH, SSL_CERT_FILE and
          GIT_SSL_CAINFO from <option>environment.sessionVariables</option>,
          NIX_REMOTE is set to "daemon" and JENKINS_HOME is set to
          the value of <option>services.jenkins.home</option>. This option has
          precedence and can be used to override those mentioned variables.
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

      environment =
        let
          selectedSessionVars =
            lib.filterAttrs (n: v: builtins.elem n
                [ "NIX_PATH"
                  "SSL_CERT_FILE"
                  "GIT_SSL_CAINFO"
                ])
              config.environment.sessionVariables;
        in
          selectedSessionVars //
          { JENKINS_HOME = cfg.home;
            NIX_REMOTE = "daemon";
          } //
          cfg.environment;

      path = cfg.packages;

      # Force .war (re)extraction, or else we might run stale Jenkins.
      preStart = ''
        rm -rf ${cfg.home}/war
      '';

      script = ''
        ${pkgs.jdk}/bin/java -jar ${pkgs.jenkins} --httpPort=${toString cfg.port} ${concatStringsSep " " cfg.extraOptions}
      '';

      postStart = ''
        until ${pkgs.curl}/bin/curl -s -L localhost:${toString cfg.port} ; do
          sleep 10
        done
      '';

      serviceConfig = {
        User = cfg.user;
      };
    };
  };
}
