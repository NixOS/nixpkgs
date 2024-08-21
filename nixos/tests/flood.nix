import ./make-test-python.nix ({ pkgs, ... }:
let
  port = 3001;
in
{
  name = "flood";
  meta = {
    maintainers = with pkgs.lib.maintainers; [ thiagokokada ];
  };

  nodes.machine = { pkgs, ... }: {
    services.flood = {
      inherit port;
      enable = true;
      openFirewall = true;
      extraArgs = [ "--baseuri=/" ];
    };
  };

  testScript = /* python */ ''
    machine.start()
    machine.wait_for_unit("flood.service")
    machine.wait_for_open_port(${toString port})

    machine.succeed("curl --fail http://localhost:${toString port}")
  '';
})
