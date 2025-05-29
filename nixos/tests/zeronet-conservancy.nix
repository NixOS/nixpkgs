{
  lib,
  ...
}:
let
  port = 43110;
in
{
  name = "zeronet-conservancy";
  meta = with lib.maintainers; {
    maintainers = [ fgaz ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services.zeronet = {
        enable = true;
        package = pkgs.zeronet-conservancy;
        inherit port;
      };
    };

  testScript = ''
    machine.wait_for_unit("zeronet.service")

    machine.wait_for_open_port(${toString port})

    machine.succeed("curl --fail -H 'Accept: text/html, application/xml, */*' localhost:${toString port}/Stats")
  '';
}
