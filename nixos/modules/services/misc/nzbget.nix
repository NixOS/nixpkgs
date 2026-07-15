{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.nzbget;
  stateDir = "/var/lib/nzbget";
  configFile = "${stateDir}/nzbget.conf";
  configOpts = lib.concatStringsSep " " (
    lib.mapAttrsToList (name: value: "-o ${name}=${lib.escapeShellArg (toStr value)}") cfg.settings
  );
  toStr =
    v:
    if v == true then
      "yes"
    else if v == false then
      "no"
    else if lib.isInt v then
      toString v
    else
      v;
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "misc"
      "nzbget"
      "configFile"
    ] "The configuration of nzbget is now managed by users through the web interface.")
    (lib.mkRemovedOptionModule [
      "services"
      "misc"
      "nzbget"
      "dataDir"
    ] "The data directory for nzbget is now /var/lib/nzbget.")
    (lib.mkRemovedOptionModule [ "services" "misc" "nzbget" "openFirewall" ]
      "The port used by nzbget is managed through the web interface so you should adjust your firewall rules accordingly."
    )
  ];

  # interface

  options = {
    services.nzbget = {
      enable = lib.mkEnableOption "NZBGet, for downloading files from news servers";

      package = lib.mkPackageOption pkgs "nzbget" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "nzbget";
        description = "User account under which NZBGet runs";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "nzbget";
        description = "Group under which NZBGet runs";
      };

      settings = lib.mkOption {
        type =
          with lib.types;
          attrsOf (oneOf [
            bool
            int
            str
          ]);
        default = { };
        description = ''
          NZBGet configuration, passed via command line using switch -o. Refer to
          <https://github.com/nzbgetcom/nzbget/blob/develop/nzbget.conf>
          for details on supported values.
        '';
        example = {
          MainDir = "/data";
        };
      };
    };
  };

  # implementation

  config = lib.mkIf cfg.enable {
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
      ConfigTemplate = "${cfg.package}/share/nzbget/nzbget.conf";
      WebDir = "${cfg.package}/share/nzbget/webui";
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
          ${pkgs.coreutils}/bin/install -m 0700 ${cfg.package}/share/nzbget/nzbget.conf ${configFile}
        fi
      '';

      serviceConfig = {
        StateDirectory = "nzbget";
        StateDirectoryMode = "0750";
        User = cfg.user;
        Group = cfg.group;
        UMask = "0002";
        Restart = "on-failure";
        ExecStart = "${cfg.package}/bin/nzbget --server --configfile ${stateDir}/nzbget.conf ${configOpts}";
        ExecStop = "${cfg.package}/bin/nzbget --quit";
      };
    };

    users.users = lib.mkIf (cfg.user == "nzbget") {
      nzbget = {
        home = stateDir;
        group = cfg.group;
        uid = config.ids.uids.nzbget;
      };
    };

    users.groups = lib.mkIf (cfg.group == "nzbget") {
      nzbget = {
        gid = config.ids.gids.nzbget;
      };
    };
  };
}
