{ lib, ... }:

{
  name = "orthanc";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.orthanc = {
          enable = true;
          settings = {
            HttpPort = 12345;
          };
        };
      };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("orthanc.service")
    machine.wait_for_open_port(12345)
    machine.wait_for_open_port(4242)
  '';

  meta.maintainers = [ ];
}
