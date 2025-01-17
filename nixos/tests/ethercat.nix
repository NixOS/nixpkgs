import ./make-test-python.nix (
  {
    pkgs,
    lib,
    ...
  }:
  let
    macAddress = "00:11:22:33:44:55";

    # ec_e1000 module is not supported on more recent kernels
    kernelPackages = pkgs.linuxPackages_5_15;
  in
  {
    name = "ethercat";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ stv0g ];
    };

    nodes.machine =
      { pkgs, config, ... }:
      {
        boot.kernelPackages = kernelPackages;

        virtualisation.qemu.networkingOptions = [
          "-net"
          "nic,model=e1000,macaddr=${macAddress}"
        ];

        hardware.ethercat = {
          enable = true;

          masters = [
            {
              primary = macAddress;
            }
          ];

          deviceModules = [
            "e1000"
          ];
        };
      };

    testScript = ''
      machine.wait_for_unit("multi-user.target")

      with subtest("EtherCAT kernel modules are loaded"):
        out = machine.succeed("lsmod")
        modules = [line.split()[0] for line in out.splitlines()]

        assert "ec_master" in modules, "ec_master not loaded"
        assert "ec_e1000" in modules, "ec_e1000 not loaded"

      with subtest("EtherCAT master is configured"):
        out = machine.succeed("dmesg")
        assert "EtherCAT: Master driver ${kernelPackages.ethercat.version}" in out
        assert "EtherCAT: Accepting ${macAddress} as main device for master 0." in out
        assert "EtherCAT: 1 master waiting for devices." in out
        assert "EtherCAT 0: Link state of ecm0 changed to UP" in out

      with subtest("Command line tool works"):
        out = machine.succeed("ethercat master --master 0")
        assert "Phase: Idle" in out
        assert "Link: UP" in out
        assert "Main: ${macAddress} (attached)" in out
    '';
  }
)
