{ config, lib, pkgs, ... }:

let
  cfg = config.services.torrentstream;
  dataDir = "/var/lib/torrentstream/";
in
{
  options.services.torrentstream = {
    enable = lib.mkEnableOption "TorrentStream daemon";
    package = lib.mkPackageOption pkgs "torrentstream" { };
    port = lib.mkOption {
      type = lib.types.port;
      default = 5082;
      description = ''
        TorrentStream port.
      '';
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open ports in the firewall for TorrentStream daemon.
      '';
    };
    address = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = ''
        Address to listen on.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.torrentstream = {
      after = [ "network.target" ];
      description = "TorrentStream Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        UMask = "077";
        StateDirectory = "torrentstream";
        DynamicUser = true;
      };
      environment = {
        WEB_PORT = toString cfg.port;
        DOWNLOAD_PATH = "%S/torrentstream";
        LISTEN_ADDR = cfg.address;
      };
    };
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
