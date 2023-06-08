{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.dynamichostnamed;
in {
  options.services.dynamichostnamed = {
    enable = mkEnableOption "dynamichostnamed";
    basename = mkOption {
      description = "Base hostname.";
      type = types.str;
    };
    uid_file = mkOption {
      description = "File path of UID to append to hostname (optional).";
      type = types.str;
      default = "";
    };
    uid_raw = mkOption {
      description = "Whether or not the UID file contents are raw bytes (default true).";
      type = types.bool;
      default = true;
    };
    uid_offset = mkOption {
      description = "Character offset in UID to begin appending from (starting from 1).";
      type = types.int;
      default = 1;
    };
  };
  config = mkIf cfg.enable {
    networking.hostName = "";

    systemd.services = {
      dynamichostnamed = {
        description = "Dynamic hostname changer.";
        restartIfChanged = true;

        # Use hostnamectl to change transient hostname, appending a UID
        # to a base hostname.
        script = ''
          set -x
          ${if cfg.uid_file == "" then ''
            hostnamectl --transient hostname ${cfg.basename}
          '' else ''
            ${if cfg.uid_raw then ''
              hostnamectl --transient hostname ${cfg.basename}-$(${pkgs.hexdump}/bin/hexdump -e '/1 "%02x"' ${cfg.uid_file} | cut -c${builtins.toString cfg.uid_offset}-)
            '' else ''
              hostnamectl --transient hostname ${cfg.basename}-$(cat ${cfg.uid_file} | cut -c${cfg.uid_offset}-)
            ''}
          ''}
        '';

        after = [ "systemd-hostnamed.service" ];
        wants = [ "systemd-hostnamed.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "oneshot";
          User = "root";
          Restart = "no";
        };
      };
    };
  };
}
