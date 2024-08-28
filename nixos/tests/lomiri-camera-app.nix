{ lib, ... }:
{
  name = "lomiri-camera-app-standalone";
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
            feh # view photo result
            ffmpeg # fake webcam stream
            gnome-text-editor # somewhere to paste QR result
            (imagemagick.override { ghostscriptSupport = true; }) # add label for OCR
            qrtool # generate QR code
            xdotool # clicking on QR button
          ]
          ++ (with pkgs.lomiri; [
            suru-icon-theme
            lomiri-camera-app
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

      # Fake camera
      boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    };

  enableOCR = true;

  testScript =
    let
      qrLabel = "Image";
      qrContent = "Test";
    in
    ''
      machine.wait_for_x()

      with subtest("lomiri camera launches"):
          machine.succeed("lomiri-camera-app >&2 &")
          machine.wait_for_text("Cannot access")
          machine.screenshot("lomiri-camera_open")

      machine.succeed("pkill -f lomiri-camera-app")

      # Setup fake v4l2 camera
      machine.succeed("modprobe v4l2loopback video_nr=10 card_label=Video-Loopback exclusive_caps=1")
      machine.succeed("qrtool encode '${qrContent}' -s 20 -m 10 > qr.png")
      # Horizontal flip, add text, flip back. Camera displays image mirrored, so need reversed text for OCR
      machine.succeed("magick qr.png -flop -pointsize 70 -fill black -annotate +100+100 '${qrLabel}' -flop output.png")
      machine.succeed("ffmpeg -re -loop 1 -i output.png -vf format=yuv420p -f v4l2 /dev/video10 -loglevel fatal >&2 &")

      with subtest("lomiri camera uses camera"):
          machine.succeed("lomiri-camera-app >&2 &")
          machine.wait_for_text("${qrLabel}")
          machine.screenshot("lomiri-camera_feed")

          machine.succeed("xdotool mousemove 320 610 click 1") # take photo
          machine.wait_until_succeeds("find /root/Pictures/camera.ubports -name '*.jpg'")

          # Check that the image is correct
          machine.send_key("ctrl-alt-right")
          machine.succeed("magick /root/Pictures/camera.ubports/IMG_00000001.jpg -flop photo_flip.png")
          machine.succeed("feh photo_flip.png >&2 &")
          machine.wait_for_text("${qrLabel}")
          machine.screenshot("lomiri-camera_photo")

      machine.succeed("pkill -f feh")
      machine.send_key("ctrl-alt-left")
      machine.succeed("pkill -f lomiri-camera-app")

      with subtest("lomiri barcode scanner uses camera"):
          machine.succeed("lomiri-camera-app --mode=barcode-reader >&2 &")
          machine.wait_for_text("${qrLabel}")
          machine.succeed("xdotool mousemove 320 610 click 1") # open up QR decode result

          # OCR is struggling to recognise the text. Click the clipboard button and paste the result somewhere else
          machine.sleep(5)
          machine.screenshot("lomiri-barcode_decode")
          machine.succeed("xdotool mousemove 350 530 click 1")
          machine.sleep(5)

          # Need to make a new window without closing camera app, otherwise clipboard content gets lost?
          machine.send_key("ctrl-alt-right")
          machine.succeed("gnome-text-editor >&2 &")
          machine.wait_for_text("New")

          # Font size up to help with OCR
          machine.send_key("ctrl-kp_add")
          machine.send_key("ctrl-kp_add")
          machine.send_key("ctrl-kp_add")
          machine.send_key("ctrl-kp_add")
          machine.send_key("ctrl-kp_add")
          machine.send_key("ctrl-kp_add")
          machine.send_key("ctrl-kp_add")
          machine.send_key("ctrl-kp_add")
          machine.send_key("ctrl-kp_add")
          machine.send_key("ctrl-kp_add")
          machine.send_key("ctrl-kp_add")
          machine.send_key("ctrl-kp_add")
          machine.send_key("ctrl-kp_add")
          machine.send_key("ctrl-kp_add")
          machine.send_key("ctrl-kp_add")
          machine.send_key("ctrl-kp_add")

          machine.send_key("ctrl-v")
          machine.wait_for_text("${qrContent}")

      machine.succeed("pkill -f gnome-text-editor")
      machine.send_key("ctrl-alt-left")
      machine.succeed("pkill -f lomiri-camera-app")

      with subtest("lomiri camera localisation works"):
          machine.succeed("env LANG=de_DE.UTF-8 lomiri-camera-app >&2 &")
          machine.wait_for_text("Kamera")
          machine.screenshot("lomiri-camera_localised")
    '';
}
