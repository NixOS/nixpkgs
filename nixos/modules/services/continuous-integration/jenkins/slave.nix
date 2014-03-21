{ config, pkgs, ... }:
with pkgs.lib;
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
        description = ''
          If true the system will be configured to work as a jenkins slave.
          If the system is also configured to work as a jenkins master then this has no effect.
          In progress: Currently only assures the jenkins user is configured.
        '';
      };

      user = mkOption {
        default = "jenkins";
        type = with types; string;
        description = ''
          User the jenkins slave agent should execute under.
        '';
      };

      group = mkOption {
        default = "jenkins";
        type = with types; string;
        description = ''
          User the jenkins slave agent should execute under.
        '';
      };

      home = mkOption {
        default = "/var/lib/jenkins";
        type = with types; string;
        description = ''
          The path to use as JENKINS_HOME. If the default user "jenkins" is configured then
          this is the home of the "jenkins" user.
        '';
      };
    };
  };

  config = mkIf (cfg.enable && !masterCfg.enable) {
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
      useDefaultShell = true;
      uid = config.ids.uids.jenkins;
    };
  };
}
