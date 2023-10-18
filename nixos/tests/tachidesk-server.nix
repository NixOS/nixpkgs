{ system ? builtins.currentSystem
, pkgs
, lib ? pkgs.lib
}:
let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;
  inherit (lib) recursiveUpdate;

  baseTestConfig = {
    meta.maintainers = with lib.maintainers; [ ratcornu ];
    nodes.machine = { pkgs, ... }: {
      services.tachidesk-server = {
        enable = true;
        settings.server.port = 1234;
      };
    };
    testScript = ''
      machine.wait_for_unit("tachidesk-server.service")
      machine.wait_for_open_port(1234)
      machine.succeed("curl --fail http://localhost:1234/")
    '';
  };
in

{
  without-auth = makeTest (recursiveUpdate baseTestConfig {
    name = "tachidesk-server-without-auth";
  });

  with-auth = makeTest (recursiveUpdate baseTestConfig {
    name = "tachidesk-server-with-auth";

    nodes.machine = { pkgs, ... }: {
      services.tachidesk-server = {
        enable = true;

        settings.server = {
          port = 1234;
          basicAuthEnabled = true;
          basicAuthUsername = "alice";
          basicAuthPasswordFile = pkgs.writeText "snakeoil-pass.txt" "pass";
        };
      };
    };
  });
}
