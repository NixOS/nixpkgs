{ lib, ... }:
{
  name = "chrony-ptp";

  meta.maintainers = with lib.maintainers; [ gkleen ];

  nodes.qemuGuest = {
    boot.kernelModules = [ "ptp_kvm" ];

    services.chrony = {
      enable = true;
      extraConfig = ''
        refclock PHC /dev/ptp_kvm poll 2 dpoll -2 offset 0 stratum 3
      '';
    };
  };

  testScript = ''
    start_all()

    qemuGuest.wait_for_unit('multi-user.target')
    qemuGuest.succeed('systemctl is-active chronyd.service')
  '';
}
