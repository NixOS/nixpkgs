import ./make-test-python.nix (
  let
    # Based on tests/forgejo.nix
    # gpg --faked-system-time='20230301T010000!' --quick-generate-key snakeoil ed25519 sign
    signingPrivateKeyId = "46623B29FA5C34C2";
    signingPrivateKey = ''
      -----BEGIN PGP PRIVATE KEY BLOCK-----

      lIYEY/6jkBYJKwYBBAHaRw8BAQdAx8OA7+Wt62c0q25ncv9hrYKLh/PNkIj6evJ8
      cZiytLD+BwMCwemO3Ltmkyz/7u0s1qHNMmERsfDnC2W7BNCrQOHa7IaADGS5dMuB
      PWYUIazwbaq7JNvxL8oRnGaSG5gYg2hAe3eMS4RVNu94mufzJoCOf7QIc25ha2Vv
      aWyIlAQTFgoAPBYhBOTisLywnHvcasPf2kZiOyn6XDTCBQJj/qOQAhsDBQkFo5qA
      BAsJCAcEFQoJCAUWAgMBAAIeBQIXgAAKCRBGYjsp+lw0wqLWAQDnVQ9g2kA+YwXw
      lQjaO43qEWqQdG31U8k9xf8zhBNJAwEA27wCWwTi6/Vm4oJGeouyCa1EJezQ9ZOq
      yYYjnCJFgwc=
      =+c3d
      -----END PGP PRIVATE KEY BLOCK-----
    '';
  in
  { lib, ... }:
  {
    name = "codeberg-pages";

    nodes.server = {
      # The pages server needs to be able to connect to a Gitea/Forgejo instance to start properly
      # Since we cannot send network requests to services running outside the sandbox, let's start
      # a simple Forgejo service to satisfy the pages server.
      services.forgejo = {
        enable = true;

        settings = {
          server = {
            HTTP_PORT = 3000;
          };

          "repository.signing".SIGNING_KEY = signingPrivateKeyId;
          repository = {
            ENABLE_PUSH_CREATE_USER = true;
            DEFAULT_PUSH_CREATE_PRIVATE = false;
          };

          service.DISABLE_REGISTRATION = true;
        };
      };

      services.codeberg-pages = {
        enable = true;
        settings = {
          NO_DNS_01 = "true";
          FORGE_ROOT = "http://127.0.0.1:3000";
          ENABLE_HTTP_SERVER = "true";
          HTTP_PORT = "5000";
          PORT = "5001";
        };
      };

      services.openssh.enable = true;
    };

    # Since we are inside
    testScript = ''
      server.wait_for_open_port(22)
      server.wait_for_open_port(3000)
      server.wait_for_unit("forgejo.service")

      # Check if we can access Forgejo's API, codeberg-pages needs this.
      server.succeed("curl http://localhost:3000/api/forgejo/v1/version")

      server.wait_for_unit("codeberg-pages.service")
      server.wait_for_open_port(5000)
      server.wait_for_open_port(5001)
      server.succeed("curl --fail https://localhost:5001")
    '';
  }
)
