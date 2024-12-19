import ./make-test-python.nix (
  { pkgs, ... }:
  /*
    SANE NixOS test
    ===============
    SANE is intrisically tied to hardware, so testing it is not straightforward.
    However:
    - a fake webcam can be created with v4l2loopback
    - sane has a backend (v4l) to use a webcam as a scanner
    This test creates a webcam /dev/video0, streams a still image with some text
    through this webcam, uses SANE to scan from the webcam, and uses OCR to check
    that the expected text was scanned.
  */
  let
    text = "66263666188646651519653683416";
    fontsConf = pkgs.makeFontsConf {
      fontDirectories = [
        pkgs.dejavu_fonts.minimal
      ];
    };
    # an image with black on white text spelling "${text}"
    # for some reason, the test fails if it's jpg instead of png
    # the font is quite large to make OCR easier
    image =
      pkgs.runCommand "image.png"
        {
          # only imagemagickBig can render text
          nativeBuildInputs = [ pkgs.imagemagickBig ];
          FONTCONFIG_FILE = fontsConf;
        }
        ''
          magick -pointsize 100 label:${text} $out
        '';
  in
  {
    name = "sane";
    nodes.machine =
      { pkgs, config, ... }:
      {
        boot = {
          # create /dev/video0 as a fake webcam whose content is filled by ffmpeg
          extraModprobeConfig = ''
            options v4l2loopback devices=1 max_buffers=2 exclusive_caps=1 card_label=VirtualCam
          '';
          kernelModules = [ "v4l2loopback" ];
          extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
        };
        systemd.services.fake-webcam = {
          wantedBy = [ "multi-user.target" ];
          description = "fill /dev/video0 with ${image}";
          /*
            HACK: /dev/video0 is a v4l2 only device, it misses one single v4l1
            ioctl, VIDIOCSPICT. But sane only supports v4l1, so it will log that this
            ioctl failed, and assume that the pixel format is Y8 (gray). So we tell
            ffmpeg to produce this pixel format.
          */
          serviceConfig.ExecStart = [
            "${pkgs.ffmpeg}/bin/ffmpeg -framerate 30 -re -stream_loop -1 -i ${image} -f v4l2 -pix_fmt gray /dev/video0"
          ];
        };
        hardware.sane.enable = true;
        system.extraDependencies = [ image ];
        environment.systemPackages = [
          pkgs.fswebcam
          pkgs.tesseract
          pkgs.v4l-utils
        ];
        environment.variables.SANE_DEBUG_V4L = "128";
      };
    testScript = ''
      start_all()
      machine.wait_for_unit("fake-webcam.service")

      # the device only appears when ffmpeg starts producing frames
      machine.wait_until_succeeds("scanimage -L | grep /dev/video0")

      machine.succeed("scanimage -L >&2")

      with subtest("debugging: /dev/video0 works"):
        machine.succeed("v4l2-ctl --all >&2")
        machine.succeed("fswebcam --no-banner /tmp/webcam.jpg")
        machine.copy_from_vm("/tmp/webcam.jpg", "webcam")

      # scan with the webcam
      machine.succeed("scanimage -o /tmp/scan.png >&2")
      machine.copy_from_vm("/tmp/scan.png", "scan")

      # the image should contain "${text}"
      output = machine.succeed("tesseract /tmp/scan.png -")
      print(output)
      assert "${text}" in output, f"expected text ${text} was not found, OCR found {output!r}"
    '';
  }
)
