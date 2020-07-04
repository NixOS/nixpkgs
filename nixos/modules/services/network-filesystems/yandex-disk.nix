{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.yandex-disk;

  dir = "/var/lib/yandex-disk";

  u = if cfg.user != null then cfg.user else "yandexdisk";

in

{

  ###### interface

  options = {

    services.yandex-disk = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "
          Whether to enable Yandex-disk client. See https://disk.yandex.ru/
        ";
      };

      username = mkOption {
        default = "";
        type = types.str;
        description = ''
          Your yandex.com login name.
        '';
      };

      password = mkOption {
        default = "";
        type = types.str;
        description = ''
          Your yandex.com password. Warning: it will be world-readable in /nix/store.
        '';
      };

      user = mkOption {
        default = null;
        description = ''
          The user the yandex-disk daemon should run as.
        '';
      };

      directory = mkOption {
        default = "/home/Yandex.Disk";
        description = "The directory to use for Yandex.Disk storage";
      };

      excludes = mkOption {
        default = "";
        type = types.commas;
        example = "data,backup";
        description = ''
          Comma-separated list of directories which are excluded from synchronization.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.users = mkIf (cfg.user == null) [ {
      name = u;
      uid = config.ids.uids.yandexdisk;
      group = "nogroup";
      home = dir;
    } ];

    systemd.services.yandex-disk = {
      description = "Yandex-disk server";

      after = [ "network.target" ];

      wantedBy = [ "multi-user.target" ];

      # FIXME: have to specify ${directory} here as well
      unitConfig.RequiresMountsFor = dir;

      script = ''
        mkdir -p -m 700 ${dir}
        chown ${u} ${dir}

        if ! test -d "${cfg.directory}" ; then
          (mkdir -p -m 755 ${cfg.directory} && chown ${u} ${cfg.directory}) ||
            exit 1
        fi

        ${pkgs.su}/bin/su -s ${pkgs.runtimeShell} ${u} \
          -c '${pkgs.yandex-disk}/bin/yandex-disk token -p ${cfg.password} ${cfg.username} ${dir}/token'

        ${pkgs.su}/bin/su -s ${pkgs.runtimeShell} ${u} \
          -c '${pkgs.yandex-disk}/bin/yandex-disk start --no-daemon -a ${dir}/token -d ${cfg.directory} --exclude-dirs=${cfg.excludes}'
      '';

    };
  };

}

