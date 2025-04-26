{
  pkgs,
  schedulerName,
  ...
}:

{
  name = "${schedulerName}";
  meta = {
    inherit (pkgs.scx.full.meta) maintainers;
  };

  nodes.machine = {
    boot.kernelPackages = pkgs.linuxPackages_latest;

    services.scx = {
      enable = true;
      scheduler = "${schedulerName}";
    };
  };

  testScript = ''
    machine.wait_for_unit("scx.service")
    machine.succeed("ps -U root -u root u | grep ${schedulerName}")
  '';
}
