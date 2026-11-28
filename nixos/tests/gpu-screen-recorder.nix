{ pkgs, lib, ... }:
{
  name = "gpu-screen-recorder";
  meta.maintainers = with lib.maintainers; [ keenanweaver ];

  enableOCR = true;

  nodes.machine = {
    imports = [
      ./common/user-account.nix
      ./common/x11.nix
    ];

    test-support.displayManager.auto.user = "alice";

    programs.gpu-screen-recorder = {
      ui.enable = true;
      gtk.enable = true;
    };

    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      asUser =
        cmd: "su - ${user.name} -c 'DISPLAY=:0 XDG_RUNTIME_DIR=/run/user/${toString user.uid} ${cmd}'";
    in
    ''
      machine.wait_for_x()

      with subtest("setcap wrappers"):
          machine.succeed("${lib.getExe' pkgs.libcap "getcap"} /run/wrappers/bin/gsr-kms-server | grep -q cap_sys_admin")
          machine.succeed("${lib.getExe' pkgs.libcap "getcap"} /run/wrappers/bin/gsr-global-hotkeys | grep -q cap_setuid")

      with subtest("gsr-global-hotkeys gets root through its wrapper"):
          machine.fail("${asUser ''${lib.getExe' pkgs.gpu-screen-recorder-ui "gsr-global-hotkeys"} --set-led \"Scroll Lock\" on''}")
          machine.fail("grep -q 1 /sys/class/leds/*::scrolllock/brightness")
          machine.succeed("${asUser ''gsr-global-hotkeys --set-led \"Scroll Lock\" on''}")
          machine.succeed("grep -q 1 /sys/class/leds/*::scrolllock/brightness")

      with subtest("user service"):
          machine.succeed("grep -q '^ExecStart=/nix/store/.*/bin/gpu-screen-recorder ' /etc/systemd/user/gpu-screen-recorder.service")

      with subtest("frontends are installed"):
          machine.succeed("${asUser "command -v gpu-screen-recorder gpu-screen-recorder-gtk gsr-ui gsr-notify gsr-ui-cli"}")

      with subtest("audio devices and applications are listed"):
          machine.wait_for_unit("pipewire-pulse.socket", "${user.name}")
          machine.succeed("${asUser "gpu-screen-recorder --list-audio-devices"} | grep -q '^default_output|'")
          machine.succeed("${asUser "gpu-screen-recorder --list-application-audio"}")

      with subtest("dlopened libraries resolve through RUNPATH"):
          machine.succeed("(${asUser "LD_DEBUG=libs gpu-screen-recorder --info 2>&1"} || true) | grep -q 'calling init: ${pkgs.libglvnd}/lib/libEGL.so.1'")
          machine.succeed("(${asUser "LD_DEBUG=libs gsr-notify --text test --timeout 1 2>&1"} || true) | grep -q 'calling init: ${pkgs.libglvnd}/lib/libGL'")

      with subtest("notification renders"):
          machine.execute("${asUser ''gsr-notify --text \"Recording has started\" --timeout 60 >/dev/null 2>&1 &''}")
          machine.wait_for_text("Recording has started")

      with subtest("GTK frontend starts and runs gpu-screen-recorder"):
          machine.execute("${asUser "gpu-screen-recorder-gtk >/dev/null 2>&1 &"}")
          machine.wait_for_text("Failed to get OpenGL information")

      # Actual recording is not tested, gsr refuses to run on llvmpipe
    '';
}
