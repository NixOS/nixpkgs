{ pkgs, lib, ... }:
{
  name = "hermes";

  meta = {
    # The aarch64 VM in CI boots under TCG (no KVM); the full X11 stack
    # outlasts the test driver's boot timeout. Same treatment as the
    # sunshine test.
    broken = pkgs.stdenv.hostPlatform.isAarch64;
    maintainers = [ lib.maintainers.NCBlizzard ];
    timeout = 600;
  };

  # Hermes is a Sunshine-derived game-stream host. This module test checks
  # that the service starts in a real (X11) desktop session and that its
  # network endpoints come up — the same approach as the sunshine test,
  # without the OCR/pairing steps.
  nodes.hermes = { config, pkgs, ... }: {
    imports = [
      ./common/x11.nix
    ];

    virtualisation.memorySize = 4096;

    services.hermes = {
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

    # The hermes service starts in the auto-logged-in graphical session and
    # opens its base-port endpoints. 48010 is base (47989) + 21, the port the
    # stream listens on; it only opens once the service is running.
    hermes.wait_for_open_port(48010, "localhost")

    # The configuration UI (base + 1) is reachable while the service is up.
    hermes.wait_for_open_port(47990, "localhost")

    # The packaged binary is present and runs.
    hermes.succeed("${pkgs.hermes}/bin/hermes --help")
  '';
}
