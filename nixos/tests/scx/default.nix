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
      beerland.configuration.services.scx.scheduler = "scx_beerland";
      bpfland.configuration.services.scx.scheduler = "scx_bpfland";
      cake.configuration.services.scx.scheduler = "scx_cake";
      chaos.configuration.services.scx.scheduler = "scx_chaos";
      cosmos.configuration.services.scx.scheduler = "scx_cosmos";
      flash.configuration.services.scx.scheduler = "scx_flash";
      flow.configuration.services.scx.scheduler = "scx_flow";
      forge.configuration.services.scx.scheduler = "scx_forge";
      lavd.configuration.services.scx.scheduler = "scx_lavd";
      p2dq.configuration.services.scx.scheduler = "scx_p2dq";
      pandemonium.configuration.services.scx.scheduler = "scx_pandemonium";
      rlfifo.configuration.services.scx.scheduler = "scx_rlfifo";
      rustland.configuration.services.scx.scheduler = "scx_rustland";
      rusty.configuration.services.scx.scheduler = "scx_rusty";
      tickless.configuration.services.scx.scheduler = "scx_tickless";
    };
  };

  testScript = ''
    specialisation = [
      "beerland",
      "bpfland",
      "cake",
      "chaos",
      "cosmos",
      "flash",
      "flow",
      "forge",
      "lavd",
      "p2dq",
      "pandemonium",
      "rlfifo",
      "rustland",
      "rusty",
      "tickless",
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
