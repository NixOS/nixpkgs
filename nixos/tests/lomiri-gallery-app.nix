{ lib, ... }:
let
  imageDataDir = "gallery-app-sampledata";
  imageLabel = "Image";
in
{
  name = "lomiri-gallery-app-standalone";
  meta.maintainers = lib.teams.lomiri.members;

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];

      services.xserver.enable = true;

      environment = {
        etc."${imageDataDir}".source =
          pkgs.runCommand imageDataDir
            {
              nativeBuildInputs = with pkgs; [
                ffmpeg # make a video from the image
                (imagemagick.override { ghostscriptSupport = true; }) # add label for OCR
              ];
            }
            ''
              mkdir -p $out/{Pictures,Videos}

              # Setup example data, OCR-friendly:
              # - White square, black text
              # - uppercase extension
              magick -size 500x500 -background white -fill black canvas:white -pointsize 70 -annotate +100+300 '${imageLabel}' $out/Pictures/output.PNG

              # Different image formats
              magick $out/Pictures/output.PNG $out/Pictures/output.JPG
              magick $out/Pictures/output.PNG $out/Pictures/output.BMP
              magick $out/Pictures/output.PNG $out/Pictures/output.GIF

              # Video for dispatching
              ffmpeg -loop 1 -r 1 -i $out/Pictures/output.PNG -t 100 -pix_fmt yuv420p $out/Videos/output.MP4
            '';
        systemPackages =
          with pkgs;
          [
            mpv # URI dispatching for video support
            xdotool # mouse movement
          ]
          ++ (with pkgs.lomiri; [
            suru-icon-theme
            lomiri-gallery-app
            lomiri-thumbnailer # finds new images & generates thumbnails
          ]);
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

  testScript =
    ''
      machine.wait_for_x()

      with subtest("lomiri gallery launches"):
          machine.succeed("lomiri-gallery-app >&2 &")
          machine.wait_for_window("gallery.ubports")
          machine.wait_for_console_text("qq= AlbumsOverview") # logged when album page actually gets loaded
          machine.sleep(10) # leniency for weak CI
          machine.wait_for_text(r"(Albums|Events|Photos)")
          machine.screenshot("lomiri-gallery_open")

      machine.succeed("pgrep -afx lomiri-gallery-app >&2")
      machine.succeed("pkill -efx lomiri-gallery-app >&2")
      machine.wait_until_fails("pgrep -afx lomiri-gallery-app >&2")

      machine.succeed("cp -vr /etc/${imageDataDir}/* /root")

      with subtest("lomiri gallery finds files"):
          machine.succeed("lomiri-gallery-app >&2 &")
          machine.wait_for_window("gallery.ubports")
          machine.wait_for_console_text("qq= AlbumsOverview") # logged when album page actually gets loaded
          machine.sleep(10) # leniency for weak CI
          machine.wait_for_text(r"(Albums|Events|Photos|${imageLabel})")

          machine.succeed("xdotool mousemove 30 40 click 1") # burger menu for categories
          machine.sleep(2)
          machine.succeed("xdotool mousemove 30 180 click 1") # photos
          machine.sleep(2)
          machine.wait_for_text("${imageLabel}") # should see thumbnail of at least one of them
          machine.screenshot("lomiri-gallery_photos")

          machine.succeed("xdotool mousemove 80 140 click 1") # select newest one
          machine.sleep(2)
          machine.succeed("xdotool mousemove 80 140 click 1") # enable top-bar
          machine.sleep(2)

      with subtest("lomiri gallery handles mp4"):
          machine.succeed("xdotool mousemove 870 50 click 1") # open media information
          machine.sleep(2)
          machine.wait_for_text("MP4") # make sure we're looking at the right file
          machine.screenshot("lomiri-gallery_mp4_info")
          machine.send_key("esc")

          machine.wait_for_text("${imageLabel}") # make sure thumbnail rendering worked

          machine.succeed("xdotool mousemove 450 350 click 1") # dispatch to system's video handler
          machine.wait_until_succeeds("pgrep -u root -f mpv") # wait for video to start
          machine.sleep(10)
          machine.succeed("pgrep -u root -f mpv") # should still be playing
          machine.screenshot("lomiri-gallery_mp4_dispatch")

          machine.send_key("q")
          machine.wait_until_fails("pgrep mpv") # wait for video to stop

      machine.send_key("right")
    ''
    +
      lib.concatMapStringsSep
        ''
          machine.send_key("right")
        ''
        (format: ''
          with subtest("lomiri gallery handles ${format.ext}"):
              machine.succeed("xdotool mousemove ${
                if format.buttonIsOffset then "840" else "870"
              } 50 click 1") # open media information
              machine.sleep(2)
              machine.wait_for_text("${format.ext}") # make sure we're looking at the right file
              machine.screenshot("lomiri-gallery_${format.ext}_info")
              machine.send_key("esc")

              machine.wait_for_text("${imageLabel}") # make sure media shows fine
        '')
        [
          {
            ext = "GIF";
            buttonIsOffset = false;
          }
          {
            ext = "BMP";
            buttonIsOffset = true;
          }
          {
            ext = "JPG";
            buttonIsOffset = true;
          }
          {
            ext = "PNG";
            buttonIsOffset = true;
          }
        ]
    + ''

      machine.succeed("pgrep -afx lomiri-gallery-app >&2")
      machine.succeed("pkill -efx lomiri-gallery-app >&2")
      machine.wait_until_fails("pgrep -afx lomiri-gallery-app >&2")

      with subtest("lomiri gallery localisation works"):
          machine.succeed("env LANG=de_DE.UTF-8 lomiri-gallery-app >&2 &")
          machine.wait_for_window("gallery.ubports")
          machine.wait_for_console_text("qq= AlbumsOverview") # logged when album page actually gets loaded
          machine.sleep(10)
          machine.wait_for_text(r"(Alben|Ereignisse|Fotos)")
          machine.screenshot("lomiri-gallery_localised")
    '';
}
