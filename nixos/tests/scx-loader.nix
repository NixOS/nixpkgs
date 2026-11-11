{ pkgs, lib, ... }:

{
  name = "scx-loader";
  meta.maintainers = with lib.maintainers; [ ccicnce113424 ] ++ pkgs.scx.full.meta.maintainers;

  nodes.machine = {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    services.scx-loader = {
      enable = true;
      config.default_sched = lib.mkDefault "scx_bpfland";
    };

    specialisation = {
      beerland.configuration.services.scx-loader.config.default_sched = "scx_beerland";
      bpfland.configuration.services.scx-loader.config.default_sched = "scx_bpfland";
      cake.configuration.services.scx-loader.config.default_sched = "scx_cake";
      cosmos.configuration.services.scx-loader.config.default_sched = "scx_cosmos";
      flash.configuration.services.scx-loader.config.default_sched = "scx_flash";
      flow.configuration.services.scx-loader.config.default_sched = "scx_flow";
      forge.configuration.services.scx-loader.config.default_sched = "scx_forge";
      lavd.configuration.services.scx-loader.config.default_sched = "scx_lavd";
      mlfq.configuration.services.scx-loader.config.default_sched = "scx_mlfq";
      p2dq.configuration.services.scx-loader.config.default_sched = "scx_p2dq";
      pandemonium.configuration.services.scx-loader.config.default_sched = "scx_pandemonium";
      rustland.configuration.services.scx-loader.config.default_sched = "scx_rustland";
      rusty.configuration.services.scx-loader.config.default_sched = "scx_rusty";
      tickless.configuration.services.scx-loader.config.default_sched = "scx_tickless";
    };
  };

  testScript = ''
    specialisation = [
        "beerland",
        "bpfland",
        "cake",
        "cosmos",
        "flash",
        "flow",
        "forge",
        "lavd",
        "mlfq",
        "p2dq",
        "pandemonium",
        "rustland",
        "rusty",
        "tickless",
    ]

    def activate_specialisation(name: str):
        machine.succeed(f"/run/booted-system/specialisation/{name}/bin/switch-to-configuration test >&2")

    machine.wait_for_unit("multi-user.target")
    output = machine.succeed("scxctl get").strip()
    assert output == "running Bpfland in Auto mode", f"Unexpected scxctl output: {output!r}"

    for sched in specialisation:
        with subtest(f"{sched}"):
            activate_specialisation(sched)
            machine.succeed("systemctl restart scx_loader.service")
            machine.succeed(f"ps -U root -u root u | grep scx_{sched}")
  '';
}
