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
      cosmos.configuration.services.scx.scheduler = "scx_cosmos";
      flash.configuration.services.scx.scheduler = "scx_flash";
      flatcg.configuration.services.scx.scheduler = "scx_flatcg";
      lavd.configuration.services.scx.scheduler = "scx_lavd";
      nest.configuration.services.scx.scheduler = "scx_nest";
      p2dq.configuration.services.scx.scheduler = "scx_p2dq";
      rlfifo.configuration.services.scx.scheduler = "scx_rlfifo";
      rustland.configuration.services.scx.scheduler = "scx_rustland";
      rusty.configuration.services.scx.scheduler = "scx_rusty";
      simple.configuration.services.scx.scheduler = "scx_simple";
    };
  };

  testScript = ''
    specialisation = [
      "beerland",
      "bpfland",
      "cosmos",
      "flash",
      "flatcg",
      "lavd",
      "nest",
      "p2dq",
      "rlfifo",
      "rustland",
      "rusty",
      "simple"
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
