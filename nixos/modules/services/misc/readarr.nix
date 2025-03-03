{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.readarr;
in
{
  options = {
    services.readarr = {
      enable = lib.mkEnableOption "Readarr, a Usenet/BitTorrent ebook downloader";

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/readarr/";
        description = "The directory where Readarr stores its data files.";
      };

      package = lib.mkPackageOption pkgs "readarr" { };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for Readarr
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "readarr";
        description = ''
          User account under which Readarr runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "readarr";
        description = ''
          Group under which Readarr runs.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings."10-readarr".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0700";
    };

    systemd.services.readarr = {
      description = "Readarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/Readarr -nobrowser -data='${cfg.dataDir}'";
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 8787 ];
    };

    users.users = lib.mkIf (cfg.user == "readarr") {
      readarr = {
        description = "Readarr service";
        home = cfg.dataDir;
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "readarr") {
      readarr = { };
    };
  };
}
