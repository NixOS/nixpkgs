{ pkgs, lib, ... }:
{
  _class = "service";
  imports = [ ./default.nix ];
  meta.maintainers = with lib.maintainers; [ aanderse ];
  config = {
    # Reload signal for php-fpm; sets systemd's `ExecReload`.
    systemd.mainExecReload = "${pkgs.coreutils}/bin/kill -USR2 $MAINPID";

    systemd.service = {
      after = [ "network.target" ];
      documentation = [ "man:php-fpm(8)" ];

      serviceConfig = {
        Type = "notify";
        RuntimeDirectory = "php-fpm";
        RuntimeDirectoryPreserve = true;
        Restart = "always";
      };
    };
  };
}
