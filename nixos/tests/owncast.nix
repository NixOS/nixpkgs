{ system ? builtins.currentSystem, config ? { }
, pkgs ? import ../.. { inherit system config; } }:

with import (nixpkgs + "/nixos/lib/testing-python.nix") { inherit system; };
makeTest {
  name = "owncast";
  meta = with pkgs.stdenv.lib.maintainers; { maintainers = [ MayNiklas ]; };

  nodes = {
    client = { ... }: {
      environment.systemPackages = [ curl ];
      services.owncast = { enable = true; };
    };
  };

  testScript = ''
    start_all()
    client.wait_for_unit("owncast.service")
    client.succeed("curl localhost:8080/api/status")
  '';
}
