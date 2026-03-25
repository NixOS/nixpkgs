{ lib, ... }:

{
  name = "autobrr";
  meta.maintainers = with lib.maintainers; [ av-gal ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.autobrr = {
        enable = true;
        # We create this secret in the Nix store (making it readable by everyone).
        # DO NOT DO THIS OUTSIDE OF TESTS!!
        environmentFile = pkgs.writeText "session_secret" "AUTOBRR__SESSION_SECRET=not-secret";
      };
    };

  testScript = ''
    machine.wait_for_unit("autobrr.service")
    machine.wait_for_open_port(7474)
    machine.succeed("curl --fail http://localhost:7474/")
  '';
}
