{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.nzbget;
  pkg = pkgs.nzbget;
  stateDir = "/var/lib/nzbget";
  configFile = "${stateDir}/nzbget.conf";
  configOpts = concatStringsSep " " (mapAttrsToList (name: value: "-o ${name}=${escapeShellArg (toStr value)}") cfg.settings);
  toStr = v:
    if v == true then "yes"
    else if v == false then "no"
    else if isInt v then toString v
    else v;
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "misc" "nzbget" "configFile" ] "The configuration of nzbget is now managed by users through the web interface.")
    (mkRemovedOptionModule [ "services" "misc" "nzbget" "dataDir" ] "The data directory for nzbget is now /var/lib/nzbget.")
    (mkRemovedOptionModule [ "services" "misc" "nzbget" "openFirewall" ] "The port used by nzbget is managed through the web interface so you should adjust your firewall rules accordingly.")
  ];

  # interface

  options = {
    services.nzbget = {
      enable = mkEnableOption "NZBGet";

      user = mkOption {
        type = types.str;
        default = "nzbget";
        description = lib.mdDoc "User account under which NZBGet runs";
      };

      group = mkOption {
        type = types.str;
        default = "nzbget";
        description = lib.mdDoc "Group under which NZBGet runs";
      };

      settings = mkOption {
        type = with types; attrsOf (oneOf [ bool int str ]);
        default = {};
        description = lib.mdDoc ''
          NZBGet configuration, passed via command line using switch -o. Refer to
          <https://github.com/nzbget/nzbget/blob/master/nzbget.conf>
          for details on supported values.
        '';
        example = {
          MainDir = "/data";
        };
      };
    };
  };

  # implementation

  config = mkIf cfg.enable {
    services.nzbget.settings = {
      # allows nzbget to run as a "simple" service
      OutputMode = "loggable";
      # use journald for logging
      WriteLog = "none";
      ErrorTarget = "screen";
      WarningTarget = "screen";
      InfoTarget = "screen";
      DetailTarget = "screen";
      # required paths
      ConfigTemplate = "${pkg}/share/nzbget/nzbget.conf";
      WebDir = "${pkg}/share/nzbget/webui";
      # nixos handles package updates
      UpdateCheck = "none";
    };

    systemd.services.nzbget = {
      description = "NZBGet Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        unrar
        p7zip
      ];

      preStart = ''
        if [ ! -f ${configFile} ]; then
          ${pkgs.coreutils}/bin/install -m 0700 ${pkg}/share/nzbget/nzbget.conf ${configFile}
        fi
      '';

      serviceConfig = {
        StateDirectory = "nzbget";
        StateDirectoryMode = "0750";
        User = cfg.user;
        Group = cfg.group;
        UMask = "0002";
        Restart = "on-failure";
        ExecStart = "${pkg}/bin/nzbget --server --configfile ${stateDir}/nzbget.conf ${configOpts}";
        ExecStop = "${pkg}/bin/nzbget --quit";
      };
    };

    users.users = mkIf (cfg.user == "nzbget") {
      nzbget = {
        home = stateDir;
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
