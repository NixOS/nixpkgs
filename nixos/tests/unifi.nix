# Test UniFi controller

{
  system ? builtins.currentSystem,
  config ? {
    allowUnfree = true;
  },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  makeAppTest =
    unifi:
    makeTest {
      name = "unifi-controller-${unifi.version}";
      meta = with pkgs.lib.maintainers; {
        maintainers = [
          patryk27
          zhaofengli
        ];
      };

      nodes.server = {
        nixpkgs.config = config;

        services.unifi = {
          enable = true;
          unifiPackage = unifi;
          openFirewall = false;
        };
      };

      testScript = ''
        server.wait_for_unit("unifi.service")
        server.wait_until_succeeds("curl -Lk https://localhost:8443 >&2", timeout=300)
      '';
    };
in
with pkgs;
{
  unifi7 = makeAppTest unifi7;
  unifi8 = makeAppTest unifi8;
}
