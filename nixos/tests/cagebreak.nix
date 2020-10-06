import ./make-test-python.nix ({ pkgs, lib, ...} :

let
  cagebreakConfigfile = pkgs.writeText "config" ''
    workspaces 1
    escape C-t
    bind t exec env DISPLAY=:0 ${pkgs.xterm}/bin/xterm -cm -pc
    bind a exec ${pkgs.alacritty}/bin/alacritty
  '';
in
{
  name = "cagebreak";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ berbiche ];
  };

  machine = { config, ... }:
  let
    alice = config.users.users.alice;
  in {
    imports = [ ./common/user-account.nix ];

    environment.systemPackages = [ pkgs.cagebreak ];
    services.xserver = {
      enable = true;
      displayManager.autoLogin = {
        enable = true;
        user = alice.name;
      };
    };
    services.xserver.windowManager.session = lib.singleton {
      manage = "desktop";
      name = "cagebreak";
      start = ''
        export XDG_RUNTIME_DIR=/run/user/${toString alice.uid}
        ${pkgs.cagebreak}/bin/cagebreak &
        waitPID=$!
      '';
    };

    systemd.services.setupCagebreakConfig = {
      wantedBy = [ "multi-user.target" ];
      before = [ "multi-user.target" ];
      environment = {
        HOME = alice.home;
      };
      unitConfig = {
        type = "oneshot";
        RemainAfterExit = true;
        user = alice.name;
      };
      script = ''
        cd $HOME
        CONFFILE=$HOME/.config/cagebreak/config
        mkdir -p $(dirname $CONFFILE)
        cp ${cagebreakConfigfile} $CONFFILE
      '';
    };

    # Copied from cage:
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
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_file("/run/user/${toString user.uid}/wayland-0")

    with subtest("ensure wayland works with alacritty"):
        machine.send_key("ctrl-t")
        machine.send_key("a")
        machine.wait_until_succeeds("pgrep alacritty")
        machine.wait_for_text("alice@machine")
        machine.screenshot("screen")
        machine.send_key("ctrl-d")

    with subtest("ensure xwayland works with xterm"):
        machine.send_key("ctrl-t")
        machine.send_key("t")
        machine.wait_until_succeeds("pgrep xterm")
        machine.wait_for_text("alice@machine")
        machine.screenshot("screen")
        machine.send_key("ctrl-d")
  '';
})
