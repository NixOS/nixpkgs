import ./make-test-python.nix ({ lib, ... }:

let
  # Change port to make sure the variable is used correctly.
  jackettPort = 9000;
  # Needs to be >=20 characters.
  apiKey = "01234567890123456789";
in

{
  name = "jackett";
  meta.maintainers = with lib.maintainers; [ etu ];

  nodes.machine =
    { pkgs, ... }: {
      services.jackett.enable = true;
      services.jackett.port = jackettPort;
      services.jackett.settings.APIKey._secret = pkgs.writeText "APIKey" apiKey;
    };

  testScript = { nodes, ... }:
    let
      cfg = nodes.machine.services.jackett;
      settings = cfg.settings;

      endpoint = "http://localhost:${toString jackettPort}";
    in
      ''
        machine.start()
        machine.wait_for_unit("jackett.service")
        machine.wait_for_open_port(${toString jackettPort})

        with subtest("can reach root endpoint"):
            machine.succeed("curl --fail ${endpoint}")

        with subtest("can reach health endpoint"):
            machine.succeed("curl --fail ${endpoint}/health")

        with subtest("can reach login endpoint"):
            machine.succeed("curl --fail ${endpoint}/UI/Login")

        with subtest("API key in config"):
            config = machine.succeed("cat ${cfg.dataDir}/ServerConfig.json")
            if "${apiKey}" not in config:
                raise Exception(f"Unexpected API Key. Want '${apiKey}', got '{config}'")
      '';
})
