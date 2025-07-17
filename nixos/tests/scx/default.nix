{ pkgs, ... }:

{
  name = "scx_full";
  meta = {
    inherit (pkgs.scx.full.meta) maintainers;
  };

  nodes.machine = {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    services.scx.enable = true;

    specialisation = {
      bpfland.configuration.services.scx.scheduler = "scx_bpfland";
      central.configuration.services.scx.scheduler = "scx_central";
      lavd.configuration.services.scx.scheduler = "scx_lavd";
      rlfifo.configuration.services.scx.scheduler = "scx_rlfifo";
      rustland.configuration.services.scx.scheduler = "scx_rustland";
      rusty.configuration.services.scx.scheduler = "scx_rusty";
    };
  };

  testScript = ''
    specialisation = [
      "bpfland",
      "central",
      "lavd",
      "rlfifo",
      "rustland",
      "rusty"
    ]

    def activate_specialisation(name: str):
      machine.succeed(f"/run/booted-system/specialisation/{name}/bin/switch-to-configuration test >&2")

    for sched in specialisation:
      with subtest(f"{sched}"):
        activate_specialisation(sched)
        machine.succeed("systemctl restart scx.service")
        machine.succeed(f"ps -U root -u root u | grep scx_{sched}")
  '';
}
