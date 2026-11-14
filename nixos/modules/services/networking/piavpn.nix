{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.piavpn;
  piaPackage = pkgs.piavpn;
in
{
  options.services.piavpn.enable = lib.mkEnableOption "Private Internet Access VPN";

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d /var/lib/piavpn 0755 root root -"
      "d /var/lib/piavpn/var 0755 root root -"
      "d /opt/piavpn 0755 root root -"

      "L+ /opt/piavpn/bin - - - - ${piaPackage}/opt/piavpn/bin"
      "L+ /opt/piavpn/lib - - - - ${piaPackage}/opt/piavpn/lib"
      "L+ /opt/piavpn/plugins - - - - ${piaPackage}/opt/piavpn/plugins"
      "L+ /opt/piavpn/qml - - - - ${piaPackage}/opt/piavpn/qml"
      "L+ /opt/piavpn/share - - - - ${piaPackage}/opt/piavpn/share"

      "L+ /opt/piavpn/var - - - - /var/lib/piavpn/var"
    ];
    users.groups = {
      piavpn = { };
      piahnsd = { };
    };

    systemd.services.piavpn = {
      description = "Private Internet Access daemon";
      wantedBy = [ "multi-user.target" ];
      requires = [ "systemd-tmpfiles-setup.service" ];
      after = [
        "network.target"
        "systemd-tmpfiles-setup.service"
      ];

      path = [
        pkgs.e2fsprogs
        pkgs.gawk
        pkgs.iproute2
        pkgs.iptables
        pkgs.openresolv
      ];

      environment = {
        LD_LIBRARY_PATH = "${piaPackage}/opt/piavpn/lib";
      };

      serviceConfig = {
        ExecStart = "${piaPackage}/opt/piavpn/bin/pia-daemon";
        Restart = "always";
        # PIA internal commands use /bin/bash
        BindReadOnlyPaths = [
          "${pkgs.bashInteractive}/bin/bash:/bin/bash"
        ];
      };
    };
  };
  meta.maintainers = with lib.maintainers; [ mikecm ];
}
