{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.nzbget;
in {
  options = {
    services.nzbget = {
      enable = mkEnableOption "NZBGet";

      package = mkOption {
        type = types.package;
        default = pkgs.nzbget;
        defaultText = "pkgs.nzbget";
        description = "The NZBGet package to use";
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/nzbget";
        description = "The directory where NZBGet stores its configuration files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the NZBGet web interface
        '';
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
        datadir=${cfg.dataDir}
        configfile=${cfg.dataDir}/nzbget.conf
        cfgtemplate=${cfg.package}/share/nzbget/nzbget.conf
        test -d $datadir || {
          echo "Creating nzbget data directory in $datadir"
          mkdir -p $datadir
        }
        test -f $configfile || {
          echo "nzbget.conf not found. Copying default config $cfgtemplate to $configfile"
          cp $cfgtemplate $configfile
          echo "Setting $configfile permissions to 0700 (needs to be written and contains plaintext credentials)"
          chmod 0700 $configfile
          echo "Setting temporary \$MAINDIR variable in default config required in order to allow nzbget to complete initial start"
          echo "Remember to change this to a proper value once NZBGet startup has been completed"
          sed -i -e 's/MainDir=.*/MainDir=\/tmp/g' $configfile
        }
        echo "Ensuring proper ownership of $datadir (${cfg.user}:${cfg.group})."
        chown -R ${cfg.user}:${cfg.group} $datadir
      '';

      script = ''
        configfile=${cfg.dataDir}/nzbget.conf
        args="--daemon --configfile $configfile"
        # The script in preStart (above) copies nzbget's config template to datadir on first run, containing paths that point to the nzbget derivation installed at the time. 
        # These paths break when nzbget is upgraded & the original derivation is garbage collected. If such broken paths are found in the config file, override them to point to 
        # the currently installed nzbget derivation.
        cfgfallback () {
          local hit=`grep -Po "(?<=^$1=).*+" "$configfile" | sed 's/[ \t]*$//'` # Strip trailing whitespace
          ( test $hit && test -e $hit ) || {
            echo "In $configfile, valid $1 not found; falling back to $1=$2"
            args+=" -o $1=$2"
          }
        }
        cfgfallback ConfigTemplate ${cfg.package}/share/nzbget/nzbget.conf
        cfgfallback WebDir ${cfg.package}/share/nzbget/webui
        ${cfg.package}/bin/nzbget $args
      '';

      serviceConfig = {
        Type = "forking";
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = "true";
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 8989 ];
    };

    users.users = mkIf (cfg.user == "nzbget") {
      nzbget = {
        group = cfg.group;
        uid = config.ids.uids.nzbget;
      };
    };

    users.groups = mkIf (cfg.group == "nzbget") {
      nzbget = {
        gid = config.ids.gids.nzbget;
      };
    };
  };
}
