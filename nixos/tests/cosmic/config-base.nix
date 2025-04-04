{ pkgs, ... }:

{
  imports = [ ../common/user-account.nix ];

  services = {
    displayManager.cosmic-greeter.enable = true;

    # For `cosmic-store` to be added to `environment.systemPackages`
    # and for it to work correctly because Flatpak is a runtime
    # dependency of `cosmic-store`.
    flatpak.enable = true;

    desktopManager.cosmic = {
      enable = true;

      # Yes, XWayland is enabled by default at the moment, but let's
      # force enable it in case the default changes down the road, for
      # whatever reason.
      xwayland.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # These two packages are used to check if a window was opened
    # under the COSMIC session or not. Kinda important.
    # TODO: Move the check from the test module to
    # `nixos/lib/test-driver/src/test_driver/machine.py` so more
    # Wayland-only testing can be done using the existing testing
    # infrastructure.
    jq
    lswt
  ];

  # So far, all COSMIC tests launch a few GUI applications. In doing
  # so, the default allocated memory to the guest of 1024M quickly
  # poses a very high risk of an OOM-shutdown which is worse than an
  # OOM-kill. Because now, the test failed, but not for a genuine
  # reason, but an OOM-shutdown. That's an inconclusive failure
  # which might possibly mask an actual failure. Not enabling
  # systemd-oomd because we need said applications running for a
  # few seconds. So instead, bump the allocated memory to the guest
  # from 1024M to 4x; 4096M.
  virtualisation.memorySize = 4096;
}
