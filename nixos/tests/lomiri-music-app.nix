{ lib, ... }:
let
  ocrContent = "Music Test";
  musicFileName = "Example";
  musicFile = "${musicFileName}.mp3";

  ocrPauseColor = "#FF00FF";
  ocrStartColor = "#00FFFF";
in
{
  name = "lomiri-music-app-standalone";
  meta.maintainers = lib.teams.lomiri.members;

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [
        ./common/auto.nix
        ./common/user-account.nix
        ./common/x11.nix
      ];

      services.xserver.enable = true;

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

        systemPackages =
          with pkgs;
          [
            xdg-user-dirs # generate XDG dirs
            xdotool # mouse movement
          ]
          ++ (with pkgs.lomiri; [
            mediascanner2
            lomiri-music-app
            lomiri-thumbnailer
            # To check if playback actually works, or is broken due to missing codecs, we need to make the app's icons more OCR-able
            (lib.meta.hiPrio (
              suru-icon-theme.overrideAttrs (oa: {
                # Colour the background in special colours, which we can OCR for
                postPatch = (oa.postPatch or "") + ''
                  substituteInPlace suru/actions/scalable/media-playback-pause.svg \
                    --replace-fail 'fill:none' 'fill:${ocrPauseColor}'

                  substituteInPlace suru/actions/scalable/media-playback-start.svg \
                    --replace-fail 'fill:none' 'fill:${ocrStartColor}'
                '';
              })
            ))
          ]);

        variables = {
          UITK_ICON_THEME = "suru";
        };
      };

      # Get mediascanner-2.0.service
      services.desktopManager.lomiri.enable = lib.mkForce true;

      # ...but stick with icewm
      services.displayManager.defaultSession = lib.mkForce "none+icewm";

      systemd.tmpfiles.settings = {
        "10-lomiri-music-app-test-setup" = {
          "/root/Music".d = {
            mode = "0755";
            user = "root";
            group = "root";
          };
          "/root/Music/${musicFile}"."C+".argument = "/etc/${musicFile}";
        };
      };

      i18n.supportedLocales = [ "all" ];
    };

  enableOCR = true;

  testScript = ''
    from collections.abc import Callable
    import tempfile
    import subprocess

    pauseColor: str = "${ocrPauseColor}"
    startColor: str = "${ocrStartColor}"

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

    machine.wait_for_x()

    # mediascanner2 needs XDG dirs to exist
    machine.succeed("xdg-user-dirs-update")

    # mediascanner2 needs to have run, is only started automatically by Lomiri
    machine.systemctl("start mediascanner-2.0.service", "root")

    with subtest("lomiri music launches"):
        machine.succeed("lomiri-music-app >&2 &")
        machine.wait_for_console_text("Queue is empty")
        machine.sleep(10)
        machine.send_key("alt-f10")
        machine.sleep(2)
        machine.wait_for_text("favorite music")
        machine.screenshot("lomiri-music")

    with subtest("lomiri music plays music"):
        machine.succeed("xdotool mousemove 30 720 click 1") # Skip intro
        machine.sleep(2)
        machine.wait_for_text("Albums")
        machine.succeed("xdotool mousemove 25 45 click 1") # Open categories
        machine.sleep(2)
        machine.wait_for_text("Tracks")
        machine.succeed("xdotool mousemove 25 240 click 1") # Switch to Tracks category
        machine.sleep(2)
        machine.wait_for_text("${musicFileName}") # the test file
        machine.screenshot("lomiri-music_listing")

        # Ensure pause colours isn't present already
        assert (
            check_for_color(pauseColor)(True) == False
        ), "pauseColor {} was present on the screen before we selected anything!".format(pauseColor)

        machine.succeed("xdotool mousemove 25 120 click 1") # Select the track

        # Waiting for pause icon to be displayed
        with machine.nested("Waiting for the screen to have pauseColor {} on it:".format(pauseColor)):
            retry(check_for_color(pauseColor))

        machine.screenshot("lomiri-music_playback")

        # Ensure play colours isn't present already
        assert (
            check_for_color(startColor)(True) == False
        ), "startColor {} was present on the screen before we were expecting it to be!".format(startColor)

        machine.succeed("xdotool mousemove 860 480 click 1") # Pause track (only works if app can actually decode the file)

        # Waiting for play icon to be displayed
        with machine.nested("Waiting for the screen to have startColor {} on it:".format(startColor)):
            retry(check_for_color(startColor))

        machine.screenshot("lomiri-music_paused")

        # Lastly, check if generated cover image got extracted properly
        # if not, indicates an issue with mediascanner / lomiri-thumbnailer
        machine.wait_for_text("${ocrContent}")

    machine.succeed("pkill -f lomiri-music-app")

    with subtest("lomiri music localisation works"):
        machine.succeed("env LANG=de_DE.UTF-8 lomiri-music-app .mp4 >&2 &")
        machine.wait_for_console_text("Restoring library queue")
        machine.sleep(10)
        machine.send_key("alt-f10")
        machine.sleep(2)
        machine.wait_for_text("Titel")
        machine.screenshot("lomiri-music_localised")
  '';
}
