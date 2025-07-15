{ lib, ... }:
let
  ocrContent = "Feed";
  videoFile = "test.webm";
in
{
  name = "lomiri-mediaplayer-app-standalone";
  meta.maintainers = lib.teams.lomiri.members;

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];

      services.xserver.enable = true;

      environment = {
        # Setup video
        etc."${videoFile}".source =
          pkgs.runCommand videoFile
            {
              nativeBuildInputs = with pkgs; [
                ffmpeg # produce video for OCR
                (imagemagick.override { ghostscriptSupport = true; }) # produce OCR-able image
              ];
            }
            ''
              magick -size 600x600 canvas:white -pointsize 20 -fill black -annotate +100+100 '${ocrContent}' output.png
              ffmpeg -re -loop 1 -i output.png -c:v libvpx -b:v 200K -t 120 $out -loglevel fatal
            '';
        systemPackages = with pkgs.lomiri; [
          suru-icon-theme
          lomiri-mediaplayer-app
        ];
        variables = {
          UITK_ICON_THEME = "suru";
        };
      };

      i18n.supportedLocales = [ "all" ];

      fonts = {
        packages = with pkgs; [
          # Intended font & helps with OCR
          ubuntu-classic
        ];
      };
    };

  enableOCR = true;

  testScript = ''
    machine.wait_for_x()

    with subtest("lomiri mediaplayer launches"):
        machine.succeed("lomiri-mediaplayer-app >&2 &")
        machine.wait_for_console_text("The name com.lomiri.content.dbus.Service was not provided")
        machine.wait_for_console_text("The name com.lomiri.content.dbus.Service was not provided") # Emitted twice
        machine.sleep(10)
        machine.send_key("alt-f10")
        machine.sleep(5)
        machine.wait_for_text(r"(Choose|Sorry|provide|content)")
        machine.screenshot("lomiri-mediaplayer_open")

    machine.succeed("pkill -f lomiri-mediaplayer-app")

    with subtest("lomiri mediaplayer plays video"):
        machine.succeed("lomiri-mediaplayer-app /etc/${videoFile} >&2 &")
        machine.wait_for_console_text("The name com.lomiri.content.dbus.Service was not provided") # Only once here
        machine.wait_for_console_text("qml: onPositionChanged")
        machine.sleep(10)
        machine.send_key("alt-f10")
        machine.sleep(5)
        machine.wait_for_text("${ocrContent}")
        machine.screenshot("lomiri-mediaplayer_playback")

    machine.succeed("pkill -f lomiri-mediaplayer-app")

    with subtest("lomiri mediaplayer localisation works"):
        # OCR struggles with finding the translated window title, and lomiri-content-hub QML isn't translated
        # Cause an error, and look for the error popup
        machine.succeed("touch invalid.mp4")
        machine.succeed("env LANG=de_DE.UTF-8 lomiri-mediaplayer-app invalid.mp4 >&2 &")
        machine.wait_for_console_text("The name com.lomiri.content.dbus.Service was not provided")
        machine.wait_for_console_text("Der Datenstrom enthält keine Daten")
        machine.sleep(10)
        machine.send_key("alt-f10")
        machine.sleep(5)
        machine.wait_for_text(r"(Fehler|Abspielen|fehlgeschlagen)")
        machine.screenshot("lomiri-mediaplayer_localised")
  '';
}
