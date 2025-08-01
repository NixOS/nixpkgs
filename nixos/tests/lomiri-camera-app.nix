let
  makeTest = import ./make-test-python.nix;
  feedLabel = "Image";
  feedQrContent = "Test";
  feedImageFile = "feed.png";
  makeFeedImage =
    pkgs:
    pkgs.runCommand feedImageFile
      {
        nativeBuildInputs = with pkgs; [
          (imagemagick.override { ghostscriptSupport = true; }) # add label for OCR
          qrtool # generate QR code
        ];
      }
      ''
        qrtool encode '${feedQrContent}' -s 20 -m 10 > qr.png

        # Horizontal flip, add text, flip back. Camera displays image mirrored, so need reversed text for OCR
        magick qr.png \
          -flop \
          -pointsize 30 -fill black -annotate +100+100 '${feedLabel}' \
          -flop \
          $out
      '';
in
{
  basic = makeTest (
    { lib, ... }:
    {
      name = "lomiri-camera-app-basic";
      meta.maintainers = lib.teams.lomiri.members;

      nodes.machine =
        { config, pkgs, ... }:
        {
          imports = [ ./common/x11.nix ];

          services.xserver.enable = true;

          environment = {
            systemPackages = with pkgs.lomiri; [
              suru-icon-theme
              lomiri-camera-app
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

      testScript =
        let
          qrLabel = "Feed";
          qrContent = "Test";
        in
        ''
          machine.wait_for_x()

          with subtest("lomiri camera launches"):
              machine.succeed("lomiri-camera-app >&2 &")
              # emitted twice
              machine.wait_for_console_text("updateViewfinderResolution: viewfinder resolutions is not known yet")
              machine.wait_for_console_text("updateViewfinderResolution: viewfinder resolutions is not known yet")
              machine.sleep(10)
              machine.send_key("alt-f10")
              machine.sleep(5)
              machine.wait_for_text("Cannot access")
              machine.screenshot("lomiri-camera_open")

          machine.succeed("pgrep -afx lomiri-camera-app >&2")
          machine.succeed("pkill -efx lomiri-camera-app >&2")
          machine.wait_until_fails("pgrep -afx lomiri-camera-app >&2")

          # Sometimes, GStreamer errors out on camera init with: CameraBin error: "Failed to allocate required memory."
          # Adding more VM memory didn't affect this. Maybe flaky in general?
          # Current assumption: Camera access gets requested in a weird/still-in-use state, so sleep abit
          machine.sleep(10)

          with subtest("lomiri camera localisation works"):
              machine.succeed("env LANG=de_DE.UTF-8 lomiri-camera-app >&2 &")
              # emitted twice
              machine.wait_for_console_text("updateViewfinderResolution: viewfinder resolutions is not known yet")
              machine.wait_for_console_text("updateViewfinderResolution: viewfinder resolutions is not known yet")
              machine.sleep(10)
              machine.send_key("alt-f10")
              machine.sleep(5)
              machine.wait_for_text("Zugriff auf")
              machine.screenshot("lomiri-camera_localised")
        '';
    }
  );

  v4l2-photo = makeTest (
    { lib, ... }:
    {
      name = "lomiri-camera-app-v4l2-photo";
      meta.maintainers = lib.teams.lomiri.members;

      nodes.machine =
        { config, pkgs, ... }:
        {
          imports = [ ./common/x11.nix ];

          services.xserver.enable = true;

          environment = {
            etc."${feedImageFile}".source = makeFeedImage pkgs;
            systemPackages =
              with pkgs;
              [
                feh # view photo result
                ffmpeg # fake webcam stream
                imagemagick # unflip webcam photo
                xdotool # clicking on camera button
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
              ubuntu-classic
            ];
          };

          # Fake camera
          boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
        };

      enableOCR = true;

      testScript = ''
        machine.wait_for_x()

        # Setup fake v4l2 camera
        machine.succeed("modprobe v4l2loopback video_nr=10 card_label=Video-Loopback exclusive_caps=1")
        machine.succeed("ffmpeg -re -loop 1 -i /etc/${feedImageFile} -vf format=yuv420p -f v4l2 /dev/video10 -loglevel fatal >&2 &")

        with subtest("lomiri camera uses camera"):
            machine.succeed("lomiri-camera-app >&2 &")
            # emitted twice
            machine.wait_for_console_text("No flash control support")
            machine.wait_for_console_text("No flash control support")
            machine.sleep(10)
            machine.send_key("alt-f10")
            machine.sleep(5)
            machine.wait_for_text("${feedLabel}")
            machine.screenshot("lomiri-camera_feed")

            machine.succeed("xdotool mousemove 510 670 click 1") # take photo
            machine.wait_until_succeeds("ls /root/Pictures/camera.ubports | grep '\\.jpg$'")

            # Check that the image is correct
            machine.send_key("ctrl-alt-right")
            machine.succeed("magick /root/Pictures/camera.ubports/IMG_00000001.jpg -flop photo_flip.png")
            machine.succeed("feh photo_flip.png >&2 &")
            machine.sleep(10)
            machine.send_key("alt-f10")
            machine.sleep(5)
            machine.wait_for_text("${feedLabel}")
            machine.screenshot("lomiri-camera_photo")
      '';
    }
  );

  v4l2-qr = makeTest (
    { lib, ... }:
    {
      name = "lomiri-camera-app-v4l2-qr";
      meta.maintainers = lib.teams.lomiri.members;

      nodes.machine =
        { config, pkgs, ... }:
        {
          imports = [ ./common/x11.nix ];

          services.xserver.enable = true;

          environment = {
            etc."${feedImageFile}".source = makeFeedImage pkgs;
            systemPackages =
              with pkgs;
              [
                ffmpeg # fake webcam stream
                xclip # inspect QR contents copied into clipboard
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
              ubuntu-classic
            ];
          };

          # Fake camera
          boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
        };

      enableOCR = true;

      testScript = ''
        machine.wait_for_x()

        # Setup fake v4l2 camera
        machine.succeed("modprobe v4l2loopback video_nr=10 card_label=Video-Loopback exclusive_caps=1")
        machine.succeed("ffmpeg -re -loop 1 -i /etc/${feedImageFile} -vf format=yuv420p -f v4l2 /dev/video10 -loglevel fatal >&2 &")

        with subtest("lomiri barcode scanner uses camera"):
            machine.succeed("lomiri-camera-app --mode=barcode-reader >&2 &")
            # emitted twice
            machine.wait_for_console_text("No flash control support")
            machine.wait_for_console_text("No flash control support")
            machine.sleep(10)
            machine.send_key("alt-f10")
            machine.sleep(5)
            machine.wait_for_text("${feedLabel}")
            machine.succeed("xdotool mousemove 510 670 click 1") # open up QR decode result

            # OCR is struggling to recognise the text. Click the clipboard button, check what got copied
            machine.sleep(5)
            machine.screenshot("lomiri-barcode_decode")
            machine.succeed("xdotool mousemove 540 590 click 1")
            machine.wait_until_succeeds("env DISPLAY=:0 xclip -selection clipboard -o | grep -q '${feedQrContent}'")
      '';
    }
  );
}
