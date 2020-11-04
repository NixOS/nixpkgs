{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.rsyncd;
  settingsFormat = pkgs.formats.ini { };
  configFile = settingsFormat.generate "rsyncd.conf" cfg.settings;
in {
  options = {
    services.rsyncd = {

      enable = mkEnableOption "the rsync daemon";

      port = mkOption {
        default = 873;
        type = types.port;
        description = "TCP port the daemon will listen on.";
      };

      settings = mkOption {
        inherit (settingsFormat) type;
        default = { };
        example = {
          global = {
            uid = "nobody";
            gid = "nobody";
            "use chroot" = true;
            "max connections" = 4;
          };
          ftp = {
            path = "/var/ftp/./pub";
            comment = "whole ftp area";
          };
          cvs = {
            path = "/data/cvs";
            comment = "CVS repository (requires authentication)";
            "auth users" = [ "tridge" "susan" ];
            "secrets file" = "/etc/rsyncd.secrets";
          };
        };
        description = ''
          Configuration for rsyncd. See
          <citerefentry><refentrytitle>rsyncd.conf</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry>.
        '';
      };

    };
  };

  imports = (map (option:
    mkRemovedOptionModule [ "services" "rsyncd" option ]
    "This option was removed in favor of `services.rsyncd.settings`.") [
      "address"
      "extraConfig"
      "motd"
      "user"
      "group"
    ]);

  config = mkIf cfg.enable {

    services.rsyncd.settings.global.port = toString cfg.port;

    systemd.services.rsyncd = {
      description = "Rsync daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart =
        "${pkgs.rsync}/bin/rsync --daemon --no-detach --config=${configFile}";
    };
  };

  meta.maintainers = with lib.maintainers; [ ehmry ];

  # TODO: socket activated rsyncd

}
