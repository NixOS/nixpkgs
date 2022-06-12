{ system ? builtins.currentSystem, config ? { }
, pkgs ? import ../.. { inherit system config; } }:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

{
  test1 = makeTest {
    name = "vector-test1";
    meta.maintainers = [ pkgs.lib.maintainers.happysalada ];

    nodes.machine = { config, pkgs, ... }: {
      services.vector = {
        enable = true;
        journaldAccess = true;
        settings = {
          sources.journald.type = "journald";

          sinks = {
            file = {
              type = "file";
              inputs = [ "journald" ];
              path = "/var/lib/vector/logs.log";
              encoding = { codec = "ndjson"; };
            };
          };
        };
      };
    };

    # ensure vector is forwarding the messages appropriately
    testScript = ''
      machine.wait_for_unit("vector.service")
      machine.succeed("test -f /var/lib/vector/logs.log")
    '';
  };
}
