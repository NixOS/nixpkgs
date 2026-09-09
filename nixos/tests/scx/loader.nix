{ pkgs, lib, ... }:

{
  name = "scx-loader";
  meta.maintainers = with lib.maintainers; [ ccicnce113424 ];

  nodes.machine = {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    services.scx-loader = {
      enable = true;
      config.default_sched = "scx_bpfland";
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    output = machine.succeed("scxctl get").strip()
    assert output == "running Bpfland in Auto mode", f"Unexpected scxctl output: {output!r}"
  '';
}
