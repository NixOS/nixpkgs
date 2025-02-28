# This test does a basic functionality check for alice-lg

{
  system ? builtins.currentSystem,
  pkgs ? import ../.. {
    inherit system;
    config = { };
  },
}:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;
  inherit (pkgs.lib) optionalString;
in
makeTest {
  name = "alice-lg";
  nodes = {
    host1 = {
      environment.systemPackages = with pkgs; [ jq ];
      services.alice-lg = {
        enable = true;
        settings = {
          server = {
            listen_http = "[::]:7340";
            enable_prefix_lookup = true;
            asn = 1;
            routes_store_refresh_parallelism = 5;
            neighbors_store_refresh_parallelism = 10000;
            routes_store_refresh_interval = 5;
            neighbors_store_refresh_interval = 5;
          };
          housekeeping = {
            interval = 5;
            force_release_memory = true;
          };
        };
      };
    };
  };

  testScript = ''
    start_all()

    host1.wait_for_unit("alice-lg.service")
    host1.wait_for_open_port(7340)
    host1.succeed("curl http://[::]:7340 | grep 'Alice BGP Looking Glass'")
  '';
}
