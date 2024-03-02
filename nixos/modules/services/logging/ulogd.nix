{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.ulogd;
  settingsFormat = pkgs.formats.ini { listsAsDuplicateKeys = true; };
  settingsFile = settingsFormat.generate "ulogd.conf" cfg.settings;
in {
  options = {
    services.ulogd = {
      enable = mkEnableOption (lib.mdDoc "ulogd");

      settings = mkOption {
        example = {
          global.stack = [
            "log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU"
            "log1:NFLOG,base1:BASE,pcap1:PCAP"
          ];

          log1.group = 2;

          pcap1 = {
            sync = 1;
            file = "/var/log/ulogd.pcap";
          };

          emu1 = {
            sync = 1;
            file = "/var/log/ulogd_pkts.log";
          };
        };
        type = settingsFormat.type;
        default = { };
        description = lib.mdDoc
          "Configuration for ulogd. See {file}`/share/doc/ulogd/` in `pkgs.ulogd.doc`.";
      };

      logLevel = mkOption {
        type = types.enum [ 1 3 5 7 8 ];
        default = 5;
        description = lib.mdDoc
          "Log level (1 = debug, 3 = info, 5 = notice, 7 = error, 8 = fatal)";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.ulogd = {
      description = "Ulogd Daemon";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-pre.target" ];
      before = [ "network-pre.target" ];

      serviceConfig = {
        ExecStart =
          "${pkgs.ulogd}/bin/ulogd -c ${settingsFile} --verbose --loglevel ${
            toString cfg.logLevel
          }";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };
}
