{ pkgs, ... }:
let
  port = 3030;
in
{
  name = "rqbit";
  meta = {
    maintainers = with pkgs.lib.maintainers; [ CodedNil ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services.rqbit = {
        httpPort = port;
        enable = true;
        openFirewall = true;
      };
    };

  testScript = /* python */ ''
    machine.start()
    machine.wait_for_unit("rqbit.service")
    machine.wait_for_open_port(${toString port})

    machine.succeed("curl --fail http://localhost:${toString port}")
  '';
}
