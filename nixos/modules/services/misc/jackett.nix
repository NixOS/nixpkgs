{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.jackett;

in
{
  options = {
    services.jackett = {
      enable = mkEnableOption "Jackett, API support for your favorite torrent trackers";

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/jackett/.config/Jackett";
        description = "The directory where Jackett stores its data files.";
      };

      listenOnAllInterfaces = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If true, listen on all public interfacts. If false, the address from the "Local bind address" option in the web UI will be used.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 9117;
        description = ''
          TCP port where the UI and API listen.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the Jackett web interface.";
      };

      user = mkOption {
        type = types.str;
        default = "jackett";
        description = "User account under which Jackett runs.";
      };

      group = mkOption {
        type = types.str;
        default = "jackett";
        description = "Group under which Jackett runs.";
      };

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "--Logging" "--Tracing" ];
        description = ''
          A list of extra command line arguments to pass to Jackett.

          See [ConsoleOptions](https://github.com/Jackett/Jackett/blob/master/src/Jackett.Common/Models/Config/ConsoleOptions.cs) in the source code or `--help` to see available options.
        '';
      };

      package = mkPackageOption pkgs "jackett" { };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.jackett = {
      description = "Jackett";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = lib.escapeShellArgs ([
          (lib.getExe cfg.package)
          "--NoUpdates"
          "--DataFolder=${cfg.dataDir}"
          "--Port=${toString cfg.port}"
          (if cfg.listenOnAllInterfaces then "--ListenPublic" else "--ListenPrivate")
        ] ++ cfg.extraArgs);
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    users.users = mkIf (cfg.user == "jackett") {
      jackett = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = config.ids.uids.jackett;
      };
    };

    users.groups = mkIf (cfg.group == "jackett") {
      jackett.gid = config.ids.gids.jackett;
    };
  };
}
