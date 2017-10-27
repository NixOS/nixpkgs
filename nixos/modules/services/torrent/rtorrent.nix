{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.rtorrent;
in
{
  options.services.rtorrent = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable a system service for rtorrent (via tmux).
        Use `sudo -u rtorrent tmux attach` to manage rtorrent,
        and `Ctrl-B d` to detach.

        If true, services.rtorrent.install is considered true, whatever its value.
      '';
    };
    install = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to install a user service for rtorrent (via tmux).
        The service must be manually started for each user with
        ``.

        The service must be manually started for each user with
        `systemctl --user start rtorrent`.  To start rtorrent on boot as a
        system service, instead set services.rtorrent.enable = true.

        Once the service has started, use `tmux -L rtorrent attach` to manage rtorrent.
      '';
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/rtorrent";
      description = ''
        If enabled as a system service, the directory where rtorrent stores its data files.
        If installed as a user service, this value is ignored.
      '';
    };

    configFile = mkOption {
      type = types.str;
      default = "/var/lib/rtorrent/rtorrent.rc";
      description = ''
        If enabled as a system service, the location of rtorrent's config file.
        If installed as a user service, this value is ignored.
      '';
    };

    userDataDir = mkOption {
      type = types.str;
      default = "rtorrent";
      description = ''
        If installed as a user service, the directory where rtorrent stores its data files relative to $HOME.
        If enabled as a system service, this value is ignored.
      '';
    };

    userConfigFile = mkOption {
      type = types.str;
      default = ".rtorrent.rc";
      description = ''
        If installed as a user service, the location of rtorrent's config file relative to $HOME.
        If enabled as a system service, this value is ignored.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "rtorrent";
      description = ''
        User account under which rtorrent runs, if enabled as a system service.
        Ignored if installed as a user service.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "rtorrent";
      description = ''
        Group under which rtorrent runs, if enabled as a system service.
        Ignored if installed as a user service.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.rtorrent;
      defaultText = "pkgs.rtorrent";
      description = "The rtorrent package to use.";
    };
  };

  config = mkIf (cfg.enable || cfg.install) {
    users.groups = mkIf (cfg.enable && cfg.group == "rtorrent") {
      rtorrent.gid = config.ids.gids.rtorrent;
    };
    users.extraUsers = mkIf (cfg.enable && cfg.user == "rtorrent") {
      rtorrent = {
        uid = config.ids.uids.rtorrent;
        group = cfg.group;
        shell = pkgs.bashInteractive;
        home = cfg.dataDir;
        createHome = true;
      };
    };
    systemd.services.rtorrent = mkIf cfg.enable {
      description = "rTorrent system service (via tmux)";
      after = [ "network.target" ];
      # Default rtorrent.rc (in preStart) uses bash, which needs to be on the $PATH
      path = [ cfg.package pkgs.tmux pkgs.bash pkgs.procps ];
      preStart = ''
        test -f "${cfg.configFile}" || {
          echo "creating default rtorrent config file at ${cfg.configFile}."
          cat > "${cfg.configFile}" << EOF
      '' + replaceStrings [ "/home/USERNAME/rtorrent" ] [ cfg.dataDir ] (readFile ./rtorrent.rc) + "\nEOF\n}";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        KillMode = "none";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.tmux}/bin/tmux new-session -c ${cfg.dataDir} -s rtorrent -n rtorrent -d rtorrent -n -o import=${cfg.configFile}";
        ExecStop = "${pkgs.bash}/bin/bash -c \"tmux send-keys -t rtorrent C-q && while pidof rtorrent > /dev/null; do sleep 0.5; done\"";
        WorkingDirectory = "${cfg.dataDir}";
        Restart = "on-failure";
      };
    };
    systemd.user.services.rtorrent = mkIf (!cfg.enable) {
      description = "rTorrent user service (via tmux)";
      after = [ "network.target" ];
      # Default rtorrent.rc (in preStart) uses bash, which needs to be on the $PATH
      path = [ cfg.package pkgs.tmux pkgs.bash pkgs.procps ];
      preStart = ''
      test -d $HOME/${cfg.userDataDir} || {
        echo "Creating rtorrent data directory at $HOME/${cfg.userDataDir}."
        mkdir $HOME/${cfg.userDataDir}
      }
      if test -e $HOME/${cfg.userDataDir}/.session/rtorrent.lock && test -z `pidof rtorrent`; then
        rm -f $HOME/${cfg.userDataDir}/.session/rtorrent.lock
      fi
      
      test -f $HOME/${cfg.userConfigFile} || {
        echo "creating default rtorrent config file at $HOME/${cfg.userConfigFile}."
        cat > $HOME/${cfg.userConfigFile} << EOF
      '' + replaceStrings [ "/home/USERNAME/rtorrent" ] [ "$HOME/${cfg.userDataDir}" ] (readFile ./rtorrent.rc) + "\nEOF\n}";
      environment = { HOME = "%h"; };
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.tmux}/bin/tmux -L rtorrent new-session -s rt -n rtorrent -d rtorrent -n -o import=%h/${cfg.userConfigFile}";
        ExecStop = "${pkgs.bash}/bin/bash -c \"tmux -L rtorrent send-keys -t rt:rtorrent.0 C-q; while pidof rtorrent > /dev/null; do echo stopping rtorrent...; sleep 1; done\"";
        Restart = "on-failure";
      };
    };
  };
}
