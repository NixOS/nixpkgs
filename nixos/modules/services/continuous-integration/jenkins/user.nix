{ config, pkgs, ... }:
with pkgs.lib;
let
  cfg = config.users.jenkins;
in {
  options = {
    users.jenkins = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the jenkins user. By default enabling a jenkins service enables the
          jenkins user. The "user" config property of the service can be used to select a different
          user.
        '';
      };

      extraGroups = mkOption {
        default = [];
        type = with types; listOf string;
        description = ''
          Extra groups of the "jenkins" user.
        '';
      };

      group = mkOption {
        default = "jenkins";
        description = ''
          Default group of "jenkins" user.
        '';
      };

      home = mkOption {
        default = "/var/lib/jenkins";
        type = types.string;
        description = ''
          Home of the "jenkins" user and JENKINS_HOME.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraGroups = optional (cfg.group == "jenkins") {
      name = "jenkins";
      gid = config.ids.gids.jenkins;
    };

    users.extraUsers = {
      jenkins = {
        description = "jenkins user";
        createHome = true;
        home = cfg.home;
        group = cfg.group;
        extraGroups = cfg.extraGroups;
        useDefaultShell = true;
        uid = config.ids.uids.jenkins;
      };
    };
  };
}
