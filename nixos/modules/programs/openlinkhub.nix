{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.openlinkhub;
  pkg = config.programs.openlinkhub.package;
in
{
  options.programs.openlinkhub = {
    enable = lib.mkEnableOption "openlinkhub";
    package = lib.mkPackageOption pkgs [ "delta" "openlinkhub" ] { };
  };

  config = lib.mkIf cfg.enable {
    users.users.openlinkhub = {
      isSystemUser = true;
      group = "openlinkhub";
    };
    users.groups.openlinkhub = { };

    systemd.services.openlinkhub = {
      description = "Open source interface for iCUE LINK System Hub, Corsair AIOs and Hubs";
      after = [ "sleep.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        for dir in database static web; do
          if ! [[ -d $dir ]]; then
            cp -r ${pkg}/share/OpenLinkHub/$dir .
            chmod -R u+w $dir
          fi
        done
      '';

      serviceConfig = {
        ExecStart = lib.getExe pkg;
        ExecReload = "kill -s HUB $MAINPID";
        User = "openlinkhub";
        Group = "openlinkhub";
        StateDirectory = "OpenLinkHub";
        WorkingDirectory = "/var/lib/OpenLinkHub";
      };
    };

    environment.systemPackages = [ pkg ];

    services.udev.packages = [ pkg ];
  };
}
