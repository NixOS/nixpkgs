{ system ? builtins.currentSystem, config ? { }
, pkgs ? import ../.. { inherit system config; } }:

with import ../lib/testing-python.nix { inherit system; };
makeTest {
  name = "owncast";
  meta = with pkgs.lib.maintainers; { maintainers = [ MayNiklas ]; };

  nodes = {
    client = { ... }: {
      environment.systemPackages = with pkgs; [ curl ];
      services.owncast = { enable = true; };
    };
  };

  testScript = ''
    start_all()
    client.wait_for_unit("owncast.service")
    client.succeed("curl localhost:8080/api/status")
  '';
}
