import ./make-test-python.nix (
  { pkgs, lib, ... }:

  let
    secretsConfigFile = pkgs.writeText "secrets.json" (
      builtins.toJSON {
        securityKeys = {
          "S0_Legacy" = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
        };
      }
    );
  in
  {
    name = "zwave-js";
    meta.maintainers = with lib.maintainers; [ graham33 ];

    nodes = {
      machine =
        { config, ... }:
        {
          services.zwave-js = {
            enable = true;
            serialPort = "/dev/null";
            extraFlags = [ "--mock-driver" ];
            inherit secretsConfigFile;
          };
        };
    };

    testScript = ''
      start_all()

      machine.wait_for_unit("zwave-js.service")
      machine.wait_for_open_port(3000)
      machine.wait_until_succeeds("journalctl --since -1m --unit zwave-js --grep 'ZwaveJS server listening'")
    '';
  }
)
