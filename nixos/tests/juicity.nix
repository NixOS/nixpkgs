import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {

    name = "juicity";

    meta = {
      maintainers = with lib.maintainers; [ oluceps ];
    };

    nodes.machine =
      { pkgs, ... }:
      {
        services.juicity.instances = [
          {
            name = "test";
            serve = true;
            credentials = [
              "cert:${./nginx-proxyprotocol/_.test.nix.cert.pem}"
              "key:${./nginx-proxyprotocol/_.test.nix.key.pem}"
            ];
            configFile = toString (
              pkgs.writeText "config.json" ''
                {
                  "listen": ":23180",
                  "users": {
                    "1846d4df-89b5-413d-b0e9-ee275a433eba": "test"
                  },

                  "certificate": "/run/credentials/juicity-test.service/cert",
                  "private_key": "/run/credentials/juicity-test.service/key",
                  "congestion_control": "bbr",
                  "log_level": "info"
                }
              ''
            );
          }
        ];
      };

    testScript = ''
      machine.wait_for_unit("juicity-test.service")
    '';

  }
)
