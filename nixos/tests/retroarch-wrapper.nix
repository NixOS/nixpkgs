{ pkgs, ... }:

let
  package = pkgs.retroarch-bare.wrapper {
    cores = [ pkgs.libretro.twenty-fortyeight ];
    settings = {
      rgui_config_directory = "/tmp/overrides";
      video_driver = "sdl2";
      input_driver = "sdl2";
      audio_driver = "null";
      microphone_enable = "false";
      menu_driver = "rgui";
      menu_show_start_screen = "false";
      video_fullscreen = "false";
      video_windowed_scale = "1";
      video_vsync = "false";
      pause_nonactive = "false";
      input_close_content = "q";
      quit_press_twice = "false";
      core_info_cache_enable = "false";
      config_save_on_exit = "true";
    };
  };
  config = pkgs.writeText "retroarch-test.cfg" ''
    libretro_directory = "/tmp/old-cores"
  '';
  override = pkgs.writeText "2048.cfg" ''
    system_directory = "/tmp/override-system"
  '';
in
{
  name = "retroarch-wrapper";
  meta.maintainers = pkgs.lib.teams.libretro.members;

  nodes.machine.imports = [ ./common/x11.nix ];

  testScript = ''
    from datetime import timedelta

    machine.wait_for_x()
    machine.succeed("mkdir -p /tmp/old-cores /tmp/overrides/2048")

    machine.succeed("cp ${config} /tmp/retroarch.cfg; chmod u+w /tmp/retroarch.cfg")
    machine.succeed("cp ${override} /tmp/overrides/2048/2048.cfg")
    machine.execute(
        "SDL_RENDER_DRIVER=software QT_QPA_PLATFORM=offscreen "
        "${package}/bin/retroarch -v -c /tmp/retroarch.cfg "
        "-L ${package}/lib/retroarch/cores/2048_libretro.so "
        "> /tmp/retroarch.log 2>&1 &"
    )
    machine.wait_for_window("RetroArch")
    machine.wait_until_succeeds("grep -q 'SET_SUPPORT_NO_GAME: yes' /tmp/retroarch.log")
    # Allow RetroArch's startup input-release gate to clear.
    machine.sleep(duration=timedelta(seconds=1))
    machine.send_key("q")
    machine.wait_until_succeeds(
        "grep -q 'starting dummy core' /tmp/retroarch.log", timeout=timedelta(seconds=30)
    )
    machine.succeed("grep -q 'Core-specific overrides found' /tmp/retroarch.log")
    machine.succeed("grep -q 'original configuration restored' /tmp/retroarch.log")
    machine.screenshot("closed-content")
    machine.succeed("pkill -TERM retroarch")
    machine.wait_until_fails("pgrep retroarch")
    machine.succeed(
        "grep -Fx 'libretro_directory = \"${package}/lib/retroarch/cores\"' /tmp/retroarch.cfg"
    )
  '';
}
