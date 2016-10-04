{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.nzbget;
  nzbget = pkgs.nzbget;
in
{
  options = {
    services.nzbget = {
      enable = mkEnableOption "NZBGet";

      package = mkOption {
        type = types.package;
        default = pkgs.nzbget;
        defaultText = "pkgs.nzbget";
        description = "The NZBGet package to use";
      };

      user = mkOption {
        type = types.str;
        default = "nzbget";
        description = "User account under which NZBGet runs";
      };

      group = mkOption {
        type = types.str;
        default = "nzbget";
        description = "Group under which NZBGet runs";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.nzbget = {
      description = "NZBGet Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        unrar
        p7zip
      ];
      preStart = ''
        test -d /var/lib/nzbget || {
          echo "Creating nzbget state directoy in /var/lib/"
          mkdir -p /var/lib/nzbget
        }
        test -f /var/lib/nzbget/nzbget.conf || {
          echo "nzbget.conf not found. Copying default config to /var/lib/nzbget/nzbget.conf"
          cp ${cfg.package}/share/nzbget/nzbget.conf /var/lib/nzbget/nzbget.conf
          echo "Setting file mode of nzbget.conf to 0700 (needs to be written and contains plaintext credentials)"
          chmod 0700 /var/lib/nzbget/nzbget.conf
          echo "Setting temporary \$MAINDIR variable in default config required in order to allow nzbget to complete initial start"
          echo "Remember to change this to a proper value once NZBGet startup has been completed"
          sed -i -e 's/MainDir=.*/MainDir=\/tmp/g' /var/lib/nzbget/nzbget.conf
        }
        echo "Ensuring proper ownership of /var/lib/nzbget (${cfg.user}:${cfg.group})."
        chown -R ${cfg.user}:${cfg.group} /var/lib/nzbget
      '';

      serviceConfig = {
        Type = "forking";
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = "true";
        ExecStart = "${cfg.package}/bin/nzbget --daemon --configfile /var/lib/nzbget/nzbget.conf";
        Restart = "on-failure";
      };
    };

    users.extraUsers = mkIf (cfg.user == "nzbget") {
      nzbget = {
        group = cfg.group;
        uid = config.ids.uids.nzbget;
      };
    };

    users.extraGroups = mkIf (cfg.group == "nzbget") {
      nzbget = {
        gid = config.ids.gids.nzbget;
      };
    };
  };
}
