let
  makeTest = import ./make-test-python.nix;
  imageDataDir = "gallery-app-sampledata";
  imageLabel = "Image";

  makeFormatTest =
    {
      file,
      buttonIsOffset ? null,
      customTest ? null,
    }:

    makeTest (
      { pkgs, lib, ... }:

      assert lib.asserts.assertMsg (
        buttonIsOffset != null || customTest != null
      ) "Must either clarify button position, or define custom test code";

      let
        format = lib.lists.last (lib.strings.splitString "." file);
      in

      {
        name = "lomiri-gallery-app-standalone-format-${format}";
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
                    # - Small text for display OCR
                    # - Big text for gallery preview OCR
                    # - uppercase extension
                    magick -size 500x500 -background white -fill black canvas:white \
                      -pointsize 20 -annotate +100+100 '${imageLabel}' \
                      -pointsize 70 -annotate +100+300 '${imageLabel}' \
                      $out/Pictures/output.PNG

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
                  glib # Poke thumbnailer to process media via gdbus
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

            # Allow us to start thumbnailer ahead-of-time, hopefully let thumbnails get processed in peace
            systemd.user.services."dbus-com.lomiri.Thumbnailer" = {
              serviceConfig = {
                Type = "dbus";
                BusName = "com.lomiri.Thumbnailer";
                ExecStart = "${pkgs.lomiri.lomiri-thumbnailer}/libexec/lomiri-thumbnailer/thumbnailer-service";
              };
            };

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

          machine.succeed("mkdir /root/${builtins.dirOf file}")
          machine.succeed("cp -vr /etc/${imageDataDir}/${file} /root/${builtins.dirOf file}")

          # Start thumbnailer, wait for idle shutdown
          machine.systemctl("start dbus-com.lomiri.Thumbnailer", "root")
          machine.wait_until_succeeds(
              "env XDG_RUNTIME_DIR=/run/user/0 "
              + "systemctl --user is-active dbus-com.lomiri.Thumbnailer"
          )
          machine.wait_for_console_text("thumbnail cache:")

          # Request thumbnail processing, get initial thumbnail image into cache
          # This can randomly take abit longer, just run it until it succeeds
          # Touch file to invalidate failure cache
          machine.wait_until_succeeds(
              "touch '/root/${file}' && "
              + "env XDG_RUNTIME_DIR=/run/user/0 "
              + "gdbus call -e "
              + "-d com.lomiri.Thumbnailer -o /com/lomiri/Thumbnailer "
              + "-m com.lomiri.Thumbnailer.GetThumbnail "
              + "'/root/${file}' "
              # Same size as source, to reduce processing - we're very close to hitting 20s on slow hardware here
              + "'@(ii) (500,500)'"
          )

          machine.wait_for_console_text("Idle timeout reached")
          machine.wait_until_fails(
              "env XDG_RUNTIME_DIR=/run/user/0 "
              + "systemctl --user is-active dbus-com.lomiri.Thumbnailer"
          )

          with subtest("lomiri gallery finds files"):
              machine.succeed("lomiri-gallery-app >&2 &")
              machine.wait_for_console_text("qq= AlbumsOverview") # logged when album page actually gets loaded
              machine.sleep(10)
              machine.send_key("alt-f10")
              machine.sleep(5)
              machine.wait_for_text(r"(Albums|Events|Photos|${imageLabel})")

              machine.succeed("xdotool mousemove 30 40 click 1") # burger menu for categories
              machine.sleep(2)
              machine.succeed("xdotool mousemove 30 180 click 1") # photos
              machine.sleep(2)
              machine.screenshot("lomiri-gallery_photos")

          machine.succeed("xdotool mousemove 80 140 click 1") # select first one
          machine.sleep(2)
          machine.succeed("xdotool mousemove 80 140 click 1") # enable top-bar
          machine.sleep(2)

        ''
        + (
          if (customTest != null) then
            customTest
          else
            ''
              with subtest("lomiri gallery handles ${format}"):
                  machine.succeed("xdotool mousemove ${
                    if buttonIsOffset then "900" else "940"
                  } 50 click 1") # open media information
                  machine.sleep(2)
                  machine.screenshot("lomiri-gallery_${format}_info")
                  machine.send_key("esc")
                  machine.sleep(2)
                  machine.wait_for_text("${imageLabel}") # make sure media shows fine
            ''
        );

      }
    );
  makeFormatTests =
    detailsList:
    builtins.listToAttrs (
      builtins.map (
        {
          name,
          file,
          buttonIsOffset ? null,
          customTest ? null,
        }:
        {
          name = "format-${name}";
          value = makeFormatTest {
            inherit
              file
              buttonIsOffset
              customTest
              ;
          };
        }
      ) detailsList
    );
in
{
  basic = makeTest (
    { lib, ... }:
    {
      name = "lomiri-gallery-app-standalone-basic";
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
                xdotool # mouse movement
              ]
              ++ (with pkgs.lomiri; [
                suru-icon-theme
                lomiri-gallery-app
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

      testScript = ''
        machine.wait_for_x()

        with subtest("lomiri gallery launches"):
            machine.succeed("lomiri-gallery-app >&2 &")
            machine.wait_for_console_text("qq= AlbumsOverview") # logged when album page actually gets loaded
            machine.sleep(10)
            machine.send_key("alt-f10")
            machine.sleep(5)
            machine.wait_for_text(r"(Albums|Events|Photos)")
            machine.screenshot("lomiri-gallery_open")

        machine.succeed("pgrep -afx lomiri-gallery-app >&2")
        machine.succeed("pkill -efx lomiri-gallery-app >&2")
        machine.wait_until_fails("pgrep -afx lomiri-gallery-app >&2")


        with subtest("lomiri gallery localisation works"):
            machine.succeed("env LANG=de_DE.UTF-8 lomiri-gallery-app >&2 &")
            machine.wait_for_console_text("qq= AlbumsOverview") # logged when album page actually gets loaded
            machine.sleep(10)
            machine.send_key("alt-f10")
            machine.sleep(5)
            machine.wait_for_text(r"(Alben|Ereignisse|Fotos)")
            machine.screenshot("lomiri-gallery_localised")
      '';
    }
  );
}
// makeFormatTests [
  {
    name = "mp4";
    file = "Videos/output.MP4";
    # MP4 gets special treatment
    customTest = ''
      with subtest("lomiri gallery handles mp4"):
          machine.succeed("xdotool mousemove 935 40 click 1") # open media information
          machine.sleep(2)
          machine.screenshot("lomiri-gallery_mp4_info")
          machine.send_key("esc")
          machine.sleep(2)

          machine.wait_for_text("${imageLabel}") # make sure thumbnail processing worked
          machine.screenshot("lomiri-gallery_mp4_thumbnail")

          machine.succeed("xdotool mousemove 510 380 click 1") # dispatch to system's video handler
          machine.wait_until_succeeds("pgrep -u root -f mpv") # wait for video to start
          machine.sleep(10)
          machine.succeed("pgrep -u root -f mpv") # should still be playing
          machine.screenshot("lomiri-gallery_mp4_dispatch")
    '';
  }
  {
    name = "gif";
    file = "Pictures/output.GIF";
    buttonIsOffset = false;
  }
  {
    name = "bmp";
    file = "Pictures/output.BMP";
    buttonIsOffset = true;
  }
  {
    name = "jpg";
    file = "Pictures/output.JPG";
    buttonIsOffset = true;
  }
  {
    name = "png";
    file = "Pictures/output.PNG";
    buttonIsOffset = true;
  }
]
