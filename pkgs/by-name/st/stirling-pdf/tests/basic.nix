{
  name = "stirling-pdf starts";

  nodes.machine =
    { pkgs, lib, ... }:
    {
      # give more memory
      virtualisation.memorySize = 2048;
      services.stirling-pdf.enable = true;
    };

  testScript = ''
    machine.wait_for_unit("default.target")
    machine.wait_for_unit("stirling-pdf.service")
    machine.wait_for_open_port(8080)
  '';
}
