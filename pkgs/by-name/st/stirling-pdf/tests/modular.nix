{
  _class = "nixosTest";

  name = "stirling-pdf-modular";

  nodes.machine =
    { pkgs, lib, ... }:
    {
      # give more memory for two instances
      virtualisation.memorySize = 4096;
      system.services.stirling-pdf-plain = pkgs.stirling-pdf.services.default;
      system.services.stirling-pdf-custom = {
        imports = [ pkgs.stirling-pdf.services.default ];
        stirling-pdf = {
          environment.SERVER_PORT = 8082;
          systemd.stateDir = "stiring-pdf-custom";
          systemd.user = "stiring-pdf-custom";
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("default.target")
    machine.wait_for_unit("stirling-pdf-plain.service")
    machine.wait_for_unit("stirling-pdf-custom.service")
    machine.wait_for_open_port(8080)
    machine.wait_for_open_port(8082)
  '';
}
