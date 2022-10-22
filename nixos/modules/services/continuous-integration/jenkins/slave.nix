{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.jenkinsSlave;
  masterCfg = config.services.jenkins;
in {
  options = {
    services.jenkinsSlave = {
      # todo:
      # * assure the profile of the jenkins user has a JRE and any specified packages. This would
      # enable ssh slaves.
      # * Optionally configure the node as a jenkins ad-hoc slave. This would imply configuration
      # properties for the master node.
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          If true the system will be configured to work as a jenkins slave.
          If the system is also configured to work as a jenkins master then this has no effect.
          In progress: Currently only assures the jenkins user is configured.
        '';
      };

      user = mkOption {
        default = "jenkins";
        type = types.str;
        description = lib.mdDoc ''
          User the jenkins slave agent should execute under.
        '';
      };

      group = mkOption {
        default = "jenkins";
        type = types.str;
        description = lib.mdDoc ''
          If the default slave agent user "jenkins" is configured then this is
          the primary group of that user.
        '';
      };

      home = mkOption {
        default = "/var/lib/jenkins";
        type = types.path;
        description = lib.mdDoc ''
          The path to use as JENKINS_HOME. If the default user "jenkins" is configured then
          this is the home of the "jenkins" user.
        '';
      };

      javaPackage = mkOption {
        default = pkgs.jdk;
        defaultText = literalExpression "pkgs.jdk";
        description = lib.mdDoc ''
          Java package to install.
        '';
        type = types.package;
      };
    };
  };

  config = mkIf (cfg.enable && !masterCfg.enable) {
    users.groups = optionalAttrs (cfg.group == "jenkins") {
      jenkins.gid = config.ids.gids.jenkins;
    };

    users.users = optionalAttrs (cfg.user == "jenkins") {
      jenkins = {
        description = "jenkins user";
        createHome = true;
        home = cfg.home;
        group = cfg.group;
        useDefaultShell = true;
        uid = config.ids.uids.jenkins;
      };
    };

    programs.java = {
      enable = true;
      package = cfg.javaPackage;
    };
  };
}
