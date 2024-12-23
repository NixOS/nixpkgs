{ lib, ... }:
let
  ocrContent = "Music Test";
  musicFile = "test.mp3";
in
{
  name = "lomiri-music-app-standalone";
  meta = {
    maintainers = lib.teams.lomiri.members;
    # This needs a Linux VM
    platforms = lib.platforms.linux;
  };

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [
        ./common/auto.nix
        ./common/user-account.nix
      ];

      test-support.displayManager.auto = {
        enable = true;
        user = "alice";
      };

      virtualisation.memorySize = 2047;

      # To control mouse via scripting
      programs.ydotool.enable = true;

      services.desktopManager.lomiri.enable = lib.mkForce true;
      services.displayManager.defaultSession = lib.mkForce "lomiri";

      environment = {
        # Setup video
        etc."${musicFile}".source =
          pkgs.runCommand musicFile
            {
              nativeBuildInputs = with pkgs; [
                ffmpeg # produce music
                (imagemagick.override { ghostscriptSupport = true; }) # produce OCR-able cover image
              ];
            }
            ''
              magick -size 400x400 canvas:white -pointsize 40 -fill black -annotate +100+100 '${ocrContent}' output.png
              ffmpeg -re \
                -f lavfi -i anullsrc=channel_layout=mono:sample_rate=44100 \
                -i output.png \
                -map 0:0 -map 1:0 \
                -id3v2_version 3 \
                -metadata:s:v title="Album cover" \
                -metadata:s:v comment="Cover (front)" \
                -t 120 \
                $out -loglevel fatal
            '';

        systemPackages = with pkgs; [
          xdg-user-dirs

          # To check if playback actually works, or is broken due to missing codecs, we need to make the app's icons more OCR-able
          (lib.meta.hiPrio (
            lomiri.suru-icon-theme.overrideAttrs (oa: {
              # Colour the background in special colours, which we can OCR for
              postPatch =
                (oa.postPatch or "")
                + ''
                  substituteInPlace suru/actions/scalable/media-playback-pause.svg \
                    --replace-fail 'fill:none' 'fill:#ff00ff'

                  substituteInPlace suru/actions/scalable/media-playback-start.svg \
                    --replace-fail 'fill:none' 'fill:#00ff00'
                '';
            })
          ))
        ];
      };

      systemd.tmpfiles.settings = {
        "10-lomiri-music-app-test-setup" = {
          "/home/alice/Music".d = {
            mode = "0755";
            user = "alice";
            group = "users";
          };
          "/home/alice/Music/${musicFile}"."C+".argument = "/etc/${musicFile}";
        };
      };

      i18n.supportedLocales = [ "all" ];
    };

  enableOCR = true;

  testScript = ''
    from collections.abc import Callable
    import tempfile
    import subprocess

    pauseColor: str = "#FF00FF"
    startColor: str = "#00FF00"

    # Based on terminal-emulators.nix' check_for_pink
    def check_for_color(color: str) -> Callable[[bool], bool]:
        def check_for_color_retry(final=False) -> bool:
            with tempfile.NamedTemporaryFile() as tmpin:
                machine.send_monitor_command("screendump {}".format(tmpin.name))

                cmd = 'convert {} -define histogram:unique-colors=true -format "%c" histogram:info:'.format(
                    tmpin.name
                )
                ret = subprocess.run(cmd, shell=True, capture_output=True)
                if ret.returncode != 0:
                    raise Exception(
                        "image analysis failed with exit code {}".format(ret.returncode)
                    )

                text = ret.stdout.decode("utf-8")
                return color in text

        return check_for_color_retry

    # Copied from lomiri tests
    def wait_for_text(text):
        """
        Wait for on-screen text, and try to optimise retry count for slow hardware.
        """
        machine.sleep(10)
        machine.wait_for_text(text)

    def toggle_maximise():
        """
        Maximise the current window.
        """
        machine.send_key("ctrl-meta_l-up")

        # For some reason, Lomiri in these VM tests very frequently opens the starter menu a few seconds after sending the above.
        # Because this isn't 100% reproducible all the time, and there is no command to await when OCR doesn't pick up some text,
        # the best we can do is send some Escape input after waiting some arbitrary time and hope that it works out fine.
        machine.sleep(5)
        machine.send_key("esc")
        machine.sleep(5)

    def mouse_click(xpos, ypos):
        """
        Move the mouse to a screen location and hit left-click.
        """

        # Need to reset to top-left, --absolute doesn't work?
        machine.execute("ydotool mousemove -- -10000 -10000")
        machine.sleep(2)

        # Move
        machine.execute(f"ydotool mousemove -- {xpos} {ypos}")
        machine.sleep(2)

        # Click (C0 - left button: down & up)
        machine.execute("ydotool click 0xC0")
        machine.sleep(2)

    def open_starter():
        """
        Open the starter, and ensure it's opened.
        """

        # Using the keybind has a chance of instantly closing the menu again? Just click the button
        mouse_click(20, 30)

    start_all()
    machine.wait_for_unit("multi-user.target")

    # The session should start, and not be stuck in i.e. a crash loop
    with subtest("lomiri starts"):
        machine.wait_until_succeeds("pgrep -u alice -f 'lomiri --mode=full-shell'")
        # Output rendering from Lomiri has started when it starts printing performance diagnostics
        machine.wait_for_console_text("Last frame took")
        # Look for datetime's clock, one of the last elements to load
        wait_for_text(r"(AM|PM)")
        machine.screenshot("lomiri_launched")

    with subtest("lomiri music launches"):
        open_starter()
        machine.send_chars("Music\n")
        machine.wait_for_text("favorite music")
        toggle_maximise()
        machine.screenshot("lomiri-music")

    with subtest("lomiri music plays music"):
        mouse_click(50, 420) # Skip intro
        mouse_click(45, 25) # Open categories
        mouse_click(45, 130) # Switch to Tracks category
        machine.wait_for_text("test") # the test file
        machine.screenshot("lomiri-music_listing")

        # Ensure pause colours isn't present already
        assert (
            check_for_color(pauseColor)(True) == False
        ), "pauseColor {} was present on the screen before we selected anything!".format(pauseColor)

        mouse_click(45, 60) # Select the track

        # Waiting for pause icon to be displayed
        with machine.nested("Waiting for the screen to have pauseColor {} on it:".format(pauseColor)):
            retry(check_for_color(pauseColor))

        machine.screenshot("lomiri-music_playback")

        # Ensure play colours isn't present already
        assert (
            check_for_color(startColor)(True) == False
        ), "startColor {} was present on the screen before we were expecting it to be!".format(startColor)

        mouse_click(600, 250) # Pause track (only works if app can actually decode the file)

        # Waiting for play icon to be displayed
        with machine.nested("Waiting for the screen to have startColor {} on it:".format(startColor)):
            retry(check_for_color(startColor))

        machine.screenshot("lomiri-music_paused")

        # Lastly, check if generated cover image got extracted properly
        # if not, indicates an issue with mediascanner / lomiri-thumbnailer
        machine.wait_for_text("${ocrContent}")

    machine.succeed("pkill -f lomiri-music-app")

    with subtest("lomiri music localisation works"):
        machine.succeed("sudo -u alice env WAYLAND_DISPLAY=wayland-0 LANG=de_DE.UTF-8 lomiri-music-app .mp4 >&2 &")
        machine.wait_for_text("Titel")
        machine.screenshot("lomiri-music_localised")
  '';
}
