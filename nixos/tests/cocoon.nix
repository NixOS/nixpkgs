{ lib, ... }:
{
  name = "cocoon";

  nodes.machine =
    { pkgs, ... }:
    {
      services.cocoon = {
        enable = true;
        settings = {
          COCOON_DID = "did:web:cocoon.example.com";
          COCOON_HOSTNAME = "cocoon.example.com";
          COCOON_CONTACT_EMAIL = "test@example.com";

          # Snake oil testing credentials
          COCOON_ADMIN_PASSWORD = "84f54c1229e02b662214e2af2df97cb6";
          COCOON_SESSION_SECRET = "8ed099b41bb67939bf4e796fd4bd618add775a9265bcb32c63d00341a0f71b6c";
          COCOON_ROTATION_KEY_PATH =
            pkgs.runCommand "rotation-key" { nativeBuildInputs = [ pkgs.cocoon ]; }
              ''
                cocoon create-rotation-key --out $out
              '';
          COCOON_JWK_PATH = pkgs.runCommand "jwk-key" { nativeBuildInputs = [ pkgs.cocoon ]; } ''
            cocoon create-private-jwk --out $out
          '';
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("cocoon.service")
    machine.wait_for_open_port(8080)
    machine.succeed("curl --fail http://localhost:8080")
  '';

  meta.maintainers = [ lib.maintainers.isabelroses ];
}
