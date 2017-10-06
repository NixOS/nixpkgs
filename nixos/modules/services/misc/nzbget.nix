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
        datadir=/var/lib/nzbget
        configfile=$datadir/nzbget.conf
        cfgtemplate_pkg=${cfg.package}/share/nzbget/nzbget.conf
        webdir_pkg=${cfg.package}/share/nzbget/webui

        test -d $datadir || {
          echo "Creating nzbget data directory in $datadir"
          mkdir -p $datadir
        }

        test -f $configfile && {
          # nzbget expects config to have a stable reference to resources in
          # /usr or /etc.  Instead our config references /nix/store (a moving
          # target), which breaks after an upgrade/ garbage collection cycle.
          # To fix this, at runtime we have the server rewrite broken links
          # to point at the current installation under /nix/store.
          webdir=`grep -Po '(?<=^WebDir=).*+' $configfile`
          test -d $webdir || {
            echo "In $configfile, updating broken WebDir=$webdir to $webdir_pkg"
            sed -i "s|$webdir|$webdir_pkg|g" $configfile
          }
          cfgtemplate=`grep -Po '(?<=^ConfigTemplate=).*+' $configfile`
          test -f $cfgtemplate || {
            echo "In $configfile, updating broken ConfigTemplate=$cfgtemplate to $cfgtemplate_pkg"
            sed -i "s|$cfgtemplate|$cfgtemplate_pkg|g" $configfile
          }
        } || {
          echo "nzbget.conf not found. Copying default config $cfgtemplate_pkg to $configfile"
          cp $cfgtemplate_pkg $configfile
          echo "Setting $configfile permissions to 0700 (needs to be written and contains plaintext credentials)"
          chmod 0700 $configfile
          echo "Setting temporary \$MAINDIR variable in default config required in order to allow nzbget to complete initial start"
          echo "Remember to change this to a proper value once NZBGet startup has been completed"
          sed -i -e 's/MainDir=.*/MainDir=\/tmp/g' $configfile
        }

        echo "Ensuring proper ownership of $datadir (${cfg.user}:${cfg.group})."
        chown -R ${cfg.user}:${cfg.group} $datadir
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
