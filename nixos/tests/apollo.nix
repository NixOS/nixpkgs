{ pkgs, lib, ... }:
{
  name = "apollo";

  meta = {
    maintainers = [ lib.maintainers.NCBlizzard ];
    timeout = 600;
  };

  # Apollo is a Sunshine-derived game-stream host. This module test checks
  # that the service starts in a real (X11) desktop session and that its
  # network endpoints come up — the same approach as the sunshine test,
  # without the OCR/pairing steps.
  nodes.apollo = { config, pkgs, ... }: {
    imports = [
      ./common/x11.nix
    ];

    virtualisation.memorySize = 4096;

    services.apollo = {
      enable = true;
      openFirewall = true;
      settings = {
        capture = "x11";
        encoder = "software";
      };
    };
  };

  testScript = ''
    start_all()

    # The apollo service starts in the auto-logged-in graphical session and
    # opens its base-port endpoints. 48010 is base (47989) + 21, the port the
    # stream listens on; it only opens once the service is running.
    apollo.wait_for_open_port(48010, "localhost")

    # The configuration UI (base + 1) is reachable while the service is up.
    apollo.wait_for_open_port(47990, "localhost")

    # The packaged binary is present and runs.
    apollo.succeed("${pkgs.apollo}/bin/apollo --help")
  '';
}
