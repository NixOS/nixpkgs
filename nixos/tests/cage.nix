import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "cage";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ matthewbauer flokli ];
  };

  machine = { ... }:

  {
    imports = [ ./common/user-account.nix ];
    services.cage = {
      enable = true;
      user = "alice";
      program = "${pkgs.xterm}/bin/xterm -cm -pc"; # disable color and bold to make OCR easier
    };

    # this needs a fairly recent kernel, otherwise:
    #   [backend/drm/util.c:215] Unable to add DRM framebuffer: No such file or directory
    #   [backend/drm/legacy.c:15] Virtual-1: Failed to set CRTC: No such file or directory
    #   [backend/drm/util.c:215] Unable to add DRM framebuffer: No such file or directory
    #   [backend/drm/legacy.c:15] Virtual-1: Failed to set CRTC: No such file or directory
    #   [backend/drm/drm.c:618] Failed to initialize renderer on connector 'Virtual-1': initial page-flip failed
    #   [backend/drm/drm.c:701] Failed to initialize renderer for plane
    boot.kernelPackages = pkgs.linuxPackages_latest;

    virtualisation.memorySize = 1024;
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
  in ''
    with subtest("Wait for cage to boot up"):
        start_all()
        machine.wait_for_file("/run/user/${toString user.uid}/wayland-0.lock")
        machine.wait_until_succeeds("pgrep xterm")
        machine.wait_for_text("alice@machine")
        machine.screenshot("screen")
  '';
})
