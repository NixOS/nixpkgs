import ./make-test-python.nix ({ pkgs, lib, ...} :

let
  cagebreakConfigfile = pkgs.writeText "config" ''
    workspaces 1
    escape C-t
    bind t exec env DISPLAY=:0 ${pkgs.xterm}/bin/xterm -cm -pc
  '';
in
{
  name = "cagebreak";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ berbiche ];
  };

  machine = { config, ... }:
  let
    alice = config.users.users.alice;
  in {
    # Automatically login on tty1 as a normal user:
    imports = [ ./common/user-account.nix ];
    services.getty.autologinUser = "alice";

    hardware.opengl.enable = true;
    programs.xwayland.enable = true;
    environment.systemPackages = [ pkgs.cagebreak pkgs.wallutils ];

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

    virtualisation.memorySize = 1024;
    # Need to switch to a different VGA card / GPU driver than the default one (std) so that Cagebreak can launch:
    virtualisation.qemu.options = [ "-vga virtio" ];
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
    XDG_RUNTIME_DIR = "/run/user/${toString user.uid}";
  in ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.wait_until_tty_matches(1, "alice\@machine")
    machine.send_chars("cagebreak\n")
    machine.wait_for_file("${XDG_RUNTIME_DIR}/wayland-0")

    with subtest("ensure wayland works with wayinfo from wallutils"):
        print(machine.succeed("env XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR} wayinfo"))

    # TODO: Fix the XWayland test (log the cagebreak output to debug):
    # with subtest("ensure xwayland works with xterm"):
    #     machine.send_key("ctrl-t")
    #     machine.send_key("t")
    #     machine.wait_until_succeeds("pgrep xterm")
    #     machine.wait_for_text("${user.name}@machine")
    #     machine.screenshot("screen")
    #     machine.send_key("ctrl-d")
  '';
})
