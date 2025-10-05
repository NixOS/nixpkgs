{ runTest }:

let
  galeneTestGroupsDir = "/var/lib/galene/groups";
  galeneTestGroupFile = "galene-test-config.json";
  galenePort = 8443;
  galeneTestGroupAdminName = "admin";
  galeneTestGroupAdminPassword = "1234";
in
{
  basic = runTest (
    { pkgs, lib, ... }:
    {
      name = "galene-works";
      meta = {
        inherit (pkgs.galene.meta) maintainers;
        platforms = lib.platforms.linux;
      };

      nodes.machine =
        { config, pkgs, ... }:
        {
          imports = [ ./common/x11.nix ];

          services.xserver.enable = true;

          environment = {
            # https://galene.org/INSTALL.html
            etc.${galeneTestGroupFile}.source = (pkgs.formats.json { }).generate galeneTestGroupFile {
              op = [
                {
                  username = galeneTestGroupAdminName;
                  password = galeneTestGroupAdminPassword;
                }
              ];
              other = [ { } ];
            };

            systemPackages = with pkgs; [
              firefox
            ];
          };

          services.galene = {
            enable = true;
            insecure = true;
            httpPort = galenePort;
            groupsDir = galeneTestGroupsDir;
          };
        };

      enableOCR = true;

      testScript = ''
        machine.wait_for_x()

        with subtest("galene starts"):
            # Starts?
            machine.wait_for_unit("galene")
            machine.wait_for_open_port(${builtins.toString galenePort})

            # Reponds fine?
            machine.succeed("curl -s -D - -o /dev/null 'http://localhost:${builtins.toString galenePort}' >&2")

        machine.succeed("cp -v /etc/${galeneTestGroupFile} ${galeneTestGroupsDir}/test.json >&2")
        machine.wait_until_succeeds("curl -s -D - -o /dev/null 'http://localhost:${builtins.toString galenePort}/group/test/' >&2")

        with subtest("galene can join group"):
            # Open site
            machine.succeed("firefox --new-window 'http://localhost:${builtins.toString galenePort}/group/test/' >&2 &")
            # Note: Firefox doesn't use a regular "-" in the window title, but "—" (Hex: 0xe2 0x80 0x94)
            machine.wait_for_window("Test — Mozilla Firefox")
            machine.send_key("ctrl-minus")
            machine.send_key("ctrl-minus")
            machine.send_key("alt-f10")
            machine.wait_for_text(r"(Galène|Username|Password|Connect)")
            machine.screenshot("galene-group-test-join")

            # Log in as admin
            machine.send_chars("${galeneTestGroupAdminName}")
            machine.send_key("tab")
            machine.send_chars("${galeneTestGroupAdminPassword}")
            machine.send_key("ret")
            machine.sleep(5)
            # Close "Remember credentials?" FF prompt
            machine.send_key("esc")
            machine.sleep(5)
            machine.wait_for_text(r"(Enable|Share|Screen)")
            machine.screenshot("galene-group-test-logged-in")
      '';
    }
  );

  file-transfer = runTest (
    { pkgs, lib, ... }:
    {
      name = "galene-file-transfer-works";
      meta = {
        inherit (pkgs.galene-file-transfer.meta) maintainers;
        platforms = lib.platforms.linux;
      };

      nodes.machine =
        { config, pkgs, ... }:
        {
          imports = [ ./common/x11.nix ];

          services.xserver.enable = true;

          environment = {
            # https://galene.org/INSTALL.html
            etc.${galeneTestGroupFile}.source = (pkgs.formats.json { }).generate galeneTestGroupFile {
              op = [
                {
                  username = galeneTestGroupAdminName;
                  password = galeneTestGroupAdminPassword;
                }
              ];
              other = [ { } ];
            };

            systemPackages = with pkgs; [
              firefox
              galene-file-transfer
            ];
          };

          services.galene = {
            enable = true;
            insecure = true;
            httpPort = galenePort;
            groupsDir = galeneTestGroupsDir;
          };
        };

      enableOCR = true;

      testScript = ''
        machine.wait_for_x()

        with subtest("galene starts"):
            # Starts?
            machine.wait_for_unit("galene")
            machine.wait_for_open_port(${builtins.toString galenePort})

            # Reponds fine?
            machine.succeed("curl -s -D - -o /dev/null 'http://localhost:${builtins.toString galenePort}' >&2")

        machine.succeed("cp -v /etc/${galeneTestGroupFile} ${galeneTestGroupsDir}/test.json >&2")
        machine.wait_until_succeeds("curl -s -D - -o /dev/null 'http://localhost:${builtins.toString galenePort}/group/test/' >&2")

        with subtest("galene can join group"):
            # Open site
            machine.succeed("firefox --new-window 'http://localhost:${builtins.toString galenePort}/group/test/' >&2 &")
            # Note: Firefox doesn't use a regular "-" in the window title, but "—" (Hex: 0xe2 0x80 0x94)
            machine.wait_for_window("Test — Mozilla Firefox")
            machine.send_key("ctrl-minus")
            machine.send_key("ctrl-minus")
            machine.send_key("alt-f10")
            machine.wait_for_text(r"(Galène|Username|Password|Connect)")
            machine.screenshot("galene-group-test-join")

            # Log in as admin
            machine.send_chars("${galeneTestGroupAdminName}")
            machine.send_key("tab")
            machine.send_chars("${galeneTestGroupAdminPassword}")
            machine.send_key("ret")
            machine.sleep(5)
            # Close "Remember credentials?" FF prompt
            machine.send_key("esc")
            machine.sleep(5)
            machine.wait_for_text(r"(Enable|Share|Screen)")
            machine.screenshot("galene-group-test-logged-in")

        with subtest("galene-file-transfer works"):
            machine.succeed(
                "galene-file-transfer "
                + "-to '${galeneTestGroupAdminName}' "
                + "-insecure 'http://localhost:${builtins.toString galenePort}/group/test/' "
                + "${galeneTestGroupsDir}/test.json " # just try sending the groups file
                + " >&2 &"
            )
            machine.sleep(5) # Give pop-up some time to appear
            machine.wait_for_text(r"(offered to send us a file|Accept|Reject|disclose your IP)")
            machine.screenshot("galene-file-transfer-dislogue")

            # Focus on Accept button
            machine.send_key("shift-tab")
            machine.send_key("shift-tab")
            machine.send_key("shift-tab")
            machine.send_key("shift-tab")

            # Accept download
            machine.sleep(2)
            machine.send_key("ret")

            # Wait until complete & matching
            machine.wait_until_succeeds(
                "diff "
                + "${galeneTestGroupsDir}/test.json " # original
                + "/root/Downloads/test.json" # Received via file-transfer
            )
      '';
    }
  );

  stream = runTest (
    { pkgs, lib, ... }:
    let
      galeneTestGroupBotName = "bot";
      galeneTestGroupBotPassword = "1234";
      galeneStreamSrtPort = 9710;
      galeneStreamFeedImage = "galene-stream-feed.png";
      galeneStreamFeedLabel = "Example";
    in
    {
      name = "galene-stream-works";
      meta = {
        # inherit (pkgs.galene-stream.meta) teams;
        inherit (pkgs.galene.meta) maintainers;
        platforms = lib.platforms.linux;
      };

      nodes.machine =
        { config, pkgs, ... }:
        {
          imports = [ ./common/x11.nix ];

          services.xserver.enable = true;

          environment = {
            # https://galene.org/INSTALL.html
            etc = {
              ${galeneTestGroupFile}.source = (pkgs.formats.json { }).generate galeneTestGroupFile {
                presenter = [
                  {
                    username = galeneTestGroupBotName;
                    password = galeneTestGroupBotPassword;
                  }
                ];
                other = [ { } ];
              };

              ${galeneStreamFeedImage}.source =
                pkgs.runCommand galeneStreamFeedImage
                  {
                    nativeBuildInputs = with pkgs; [
                      (imagemagick.override { ghostscriptSupport = true; }) # Add text to image
                    ];
                  }
                  ''
                    magick -size 400x400 -background white -fill black canvas:white -pointsize 70 -annotate +100+200 '${galeneStreamFeedLabel}' $out
                  '';
            };

            systemPackages = with pkgs; [
              ffmpeg
              firefox
              galene-stream
            ];
          };

          services.galene = {
            enable = true;
            insecure = true;
            httpPort = galenePort;
            groupsDir = galeneTestGroupsDir;
          };
        };

      enableOCR = true;

      testScript = ''
        machine.wait_for_x()

        with subtest("galene starts"):
            # Starts?
            machine.wait_for_unit("galene")
            machine.wait_for_open_port(${builtins.toString galenePort})

            # Reponds fine?
            machine.succeed("curl -s -D - -o /dev/null 'http://localhost:${builtins.toString galenePort}' >&2")

        machine.succeed("cp -v /etc/${galeneTestGroupFile} ${galeneTestGroupsDir}/test.json >&2")
        machine.wait_until_succeeds("curl -s -D - -o /dev/null 'http://localhost:${builtins.toString galenePort}/group/test/' >&2")

        with subtest("galene-stream works"):
            # Start interface for stream data
            machine.succeed(
                "galene-stream "
                + "--input 'srt://localhost:${builtins.toString galeneStreamSrtPort}?mode=listener' "
                + "--insecure --output 'http://localhost:${builtins.toString galenePort}/group/test/' "
                + "--username ${galeneTestGroupBotName} --password ${galeneTestGroupBotPassword} "
                + ">&2 &"
            )
            machine.wait_for_console_text("Waiting for incoming stream...")

            # Start streaming
            machine.succeed(
                "ffmpeg "
                + "-f lavfi -i anullsrc=channel_layout=stereo:sample_rate=48000 " # need an audio track
                + "-re -loop 1 -i /etc/${galeneStreamFeedImage} " # loop of feed image
                + "-map 0:a -map 1:v " # arrange the output stream to have silent audio & looped video
                + "-c:a mp2 " # stream audio codec
                + "-c:v libx264 -pix_fmt yuv420p " # stream video codec
                + "-f mpegts " # stream format
                + "'srt://localhost:${builtins.toString galeneStreamSrtPort}' "
                + ">/dev/null 2>&1 &"
            )
            machine.wait_for_console_text("Setting remote session description")

            # Open site
            machine.succeed("firefox --new-window 'http://localhost:${builtins.toString galenePort}/group/test/' >&2 &")
            # Note: Firefox doesn't use a regular "-" in the window title, but "—" (Hex: 0xe2 0x80 0x94)
            machine.wait_for_window("Test — Mozilla Firefox")
            machine.send_key("ctrl-minus")
            machine.send_key("ctrl-minus")
            machine.send_key("alt-f10")
            machine.wait_for_text(r"(Galène|Username|Password|Connect)")
            machine.screenshot("galene-group-test-join")

            # Log in as anon
            machine.send_key("ret")
            machine.sleep(5)
            # Close "Remember credentials?" FF prompt
            machine.send_key("esc")
            machine.sleep(5)

            # Look for stream
            machine.wait_for_text("${galeneStreamFeedLabel}")
            machine.screenshot("galene-stream-group-test-streams")
      '';
    }
  );
}
