{ lib, ... }:
{

  name = "daed";

  meta = {
    maintainers = with lib.maintainers; [ ccicnce113424 ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.curl ];
      services.daed = {
        enable = true;
        listen = "127.0.0.1:2023";
      };
    };

  testScript = ''
    machine.wait_for_unit("daed.service")

    machine.wait_for_open_port(2023)

    machine.succeed("curl --fail --max-time 10 http://127.0.0.1:2023")
  '';

}
