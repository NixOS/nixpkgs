{ lib, ... }:
{
  name = "lomiri-gallery-app-standalone";
  meta.maintainers = lib.teams.lomiri.members;

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];

      services.xserver.enable = true;

      environment = {
        systemPackages =
          with pkgs;
          [
            ffmpeg # make a video from the image
            (imagemagick.override { ghostscriptSupport = true; }) # example image creation
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
          ubuntu_font_family
        ];
      };
    };

  enableOCR = true;

  testScript =
    let
      imageLabel = "Image";
    in
    ''
      machine.wait_for_x()

      with subtest("lomiri gallery launches"):
          machine.succeed("lomiri-gallery-app >&2 &")
          machine.sleep(2)
          machine.wait_for_text(r"(Albums|Events|Photos)")
          machine.screenshot("lomiri-gallery_open")

      machine.succeed("pkill -f lomiri-gallery-app")

      machine.succeed("mkdir /root/Pictures /root/Videos")
      # Setup example data, OCR-friendly:
      # - White square, black text
      # - uppercase extension
      machine.succeed("magick -size 500x500 -background white -fill black canvas:white -pointsize 70 -annotate +100+300 '${imageLabel}' /root/Pictures/output.PNG")

      # Different image formats
      machine.succeed("magick /root/Pictures/output.PNG /root/Pictures/output.JPG")
      machine.succeed("magick /root/Pictures/output.PNG /root/Pictures/output.BMP")
      machine.succeed("magick /root/Pictures/output.PNG /root/Pictures/output.GIF")

      # Video for dispatching
      machine.succeed("ffmpeg -loop 1 -r 1 -i /root/Pictures/output.PNG -t 100 -pix_fmt yuv420p /root/Videos/output.MP4")

      with subtest("lomiri gallery handles files"):
          machine.succeed("lomiri-gallery-app >&2 &")
          machine.sleep(2)
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

          with subtest("lomiri gallery handles gif"):
              machine.succeed("xdotool mousemove 870 50 click 1") # open media information
              machine.sleep(2)
              machine.wait_for_text("GIF") # make sure we're looking at the right file
              machine.screenshot("lomiri-gallery_gif_info")
              machine.send_key("esc")

              machine.wait_for_text("${imageLabel}") # make sure media shows fine
              machine.send_key("right")

          with subtest("lomiri gallery handles bmp"):
              machine.succeed("xdotool mousemove 840 50 click 1") # open media information (extra icon, different location)
              machine.sleep(2)
              machine.wait_for_text("BMP") # make sure we're looking at the right file
              machine.screenshot("lomiri-gallery_bmp_info")
              machine.send_key("esc")

              machine.wait_for_text("${imageLabel}") # make sure media shows fine
              machine.send_key("right")

          with subtest("lomiri gallery handles jpg"):
              machine.succeed("xdotool mousemove 840 50 click 1") # open media information (extra icon, different location)
              machine.sleep(2)
              machine.wait_for_text("JPG") # make sure we're looking at the right file
              machine.screenshot("lomiri-gallery_jpg_info")
              machine.send_key("esc")

              machine.wait_for_text("${imageLabel}") # make sure media shows fine
              machine.send_key("right")

          with subtest("lomiri gallery handles png"):
              machine.succeed("xdotool mousemove 840 50 click 1") # open media information (extra icon, different location)
              machine.sleep(2)
              machine.wait_for_text("PNG") # make sure we're looking at the right file
              machine.screenshot("lomiri-gallery_png_info")
              machine.send_key("esc")

              machine.wait_for_text("${imageLabel}") # make sure media shows fine

      machine.succeed("pkill -f lomiri-gallery-app")

      with subtest("lomiri gallery localisation works"):
          machine.succeed("env LANG=de_DE.UTF-8 lomiri-gallery-app >&2 &")
          machine.wait_for_text(r"(Alben|Ereignisse|Fotos)")
          machine.screenshot("lomiri-gallery_localised")
    '';
}
