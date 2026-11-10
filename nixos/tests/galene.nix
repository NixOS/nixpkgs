{ runTest }:

let
  galeneTestGroupsDir = "/var/lib/galene/groups";
  galeneTestGroupFile = "galene-test-config.json";
  galenePort = 8443;
  galeneTestGroupAdminName = "admin";
  galeneTestGroupAdminPassword = "1234";

  commonService =
    { pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];
      services.xserver.enable = true;
      services.galene = {
        enable = true;
        insecure = true;
        httpPort = galenePort;
        groupsDir = galeneTestGroupsDir;
      };
      environment.systemPackages = [
        (pkgs.firefox.override {
          extraPrefs = ''
            defaultPref("media.peerconnection.ice.obfuscate_host_addresses", false);
          '';
        })
      ];
    };

  interactiveConfig = {
    sshBackdoor.enable = true;
    nodes.machine = {
      virtualisation.memorySize = 4096;
      virtualisation.cores = 4;
      virtualisation.forwardPorts = [
        {
          from = "host";
          host.port = galenePort;
          guest.port = galenePort;
        }
      ];
      networking.firewall.allowedTCPPorts = [ galenePort ];
    };
  };

  mkGroupConfigFile =
    pkgs: groupConfig: (pkgs.formats.json { }).generate galeneTestGroupFile groupConfig;

  adminGroupConfig =
    pkgs:
    mkGroupConfigFile pkgs {
      op = [
        {
          username = galeneTestGroupAdminName;
          password = galeneTestGroupAdminPassword;
        }
      ];
      other = [ { } ];
    };

  startGaleneScript = ''
    with subtest("galene starts"):
        # Starts?
        machine.wait_for_unit("galene")
        machine.wait_for_open_port(${toString galenePort})

        # Responds fine?
        machine.succeed("curl -s -D - -o /dev/null 'http://localhost:${toString galenePort}' >&2")

    machine.succeed("cp -v /etc/${galeneTestGroupFile} ${galeneTestGroupsDir}/test.json >&2")
    machine.wait_until_succeeds("curl -s -D - -o /dev/null 'http://localhost:${toString galenePort}/group/test/' >&2")
  '';

  firefoxLoginScript = username: password: ''
    with subtest("galene can join group"):
        # Open site
        machine.succeed("firefox --new-window 'http://localhost:${toString galenePort}/group/test/' >&2 &")
        # Note: Firefox doesn't use a regular "-" in the window title, but "—" (Hex: 0xe2 0x80 0x94)
        machine.wait_for_window("Test — Mozilla Firefox")
        machine.send_key("ctrl-minus")
        machine.send_key("ctrl-minus")
        machine.send_key("alt-f10")
        machine.wait_for_text(r"(Galène|Username|Password|Connect)")
        machine.screenshot("galene-group-test-join")

        # Log in
        machine.send_chars("${username}")
        machine.send_key("tab")
        machine.send_chars("${password}")
        machine.send_key("ret")
        machine.sleep(5)
        # Close "Remember credentials?" FF prompt
        machine.send_key("esc")
        machine.sleep(5)
        machine.wait_for_text(r"(Enable|Share|Screen)")
        machine.screenshot("galene-group-test-logged-in")
  '';
in
{
  basic = runTest (
    { pkgs, lib, ... }:
    {
      name = "galene-works";
      meta = {
        inherit (pkgs.galene.meta) teams maintainers;
        platforms = lib.platforms.linux;
      };

      nodes.machine =
        { config, pkgs, ... }:
        {
          imports = [ commonService ];

          environment = {
            # https://galene.org/INSTALL.html
            etc.${galeneTestGroupFile}.source = adminGroupConfig pkgs;
          };
        };

      enableOCR = true;
      interactive = interactiveConfig;

      testScript = ''
        machine.wait_for_x()

        ${startGaleneScript}

        ${firefoxLoginScript galeneTestGroupAdminName galeneTestGroupAdminPassword}
      '';
    }
  );

  file-transfer = runTest (
    { pkgs, lib, ... }:
    {
      name = "galene-file-transfer-works";
      meta = {
        inherit (pkgs.galene-file-transfer.meta) teams maintainers;
        platforms = lib.platforms.linux;
      };

      nodes.machine =
        { config, pkgs, ... }:
        {
          imports = [ commonService ];

          environment = {
            # https://galene.org/INSTALL.html
            etc.${galeneTestGroupFile}.source = adminGroupConfig pkgs;

            systemPackages = with pkgs; [
              galene-file-transfer
            ];
          };
        };

      enableOCR = true;
      interactive = interactiveConfig;

      testScript = ''
        machine.wait_for_x()

        ${startGaleneScript}

        ${firefoxLoginScript galeneTestGroupAdminName galeneTestGroupAdminPassword}

        with subtest("galene-file-transfer works"):
            machine.succeed(
                "galene-file-transfer "
                + "-to '${galeneTestGroupAdminName}' "
                + "-insecure 'http://localhost:${toString galenePort}/group/test/' "
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
        inherit (pkgs.galene-stream.meta) teams maintainers;
        platforms = lib.platforms.linux;
      };

      nodes.machine =
        { config, pkgs, ... }:
        {
          imports = [ commonService ];

          environment = {
            # https://galene.org/INSTALL.html
            etc = {
              ${galeneTestGroupFile}.source = mkGroupConfigFile pkgs {
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
              galene-stream
            ];
          };
        };

      enableOCR = true;
      interactive = interactiveConfig;

      testScript = ''
        machine.wait_for_x()

        ${startGaleneScript}

        with subtest("galene-stream works"):
            # Start interface for stream data
            machine.succeed(
                "galene-stream "
                + "--input 'srt://localhost:${toString galeneStreamSrtPort}?mode=listener' "
                + "--insecure --output 'http://localhost:${toString galenePort}/group/test/' "
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
                + "'srt://localhost:${toString galeneStreamSrtPort}' "
                + ">/dev/null 2>&1 &"
            )
            machine.wait_for_console_text("Setting remote session description")

            # Open site
            machine.succeed("firefox --new-window 'http://localhost:${toString galenePort}/group/test/' >&2 &")
            # Note: Firefox doesn't use a regular "-" in the window title, but "—" (Hex: 0xe2 0x80 0x94)
            machine.wait_for_window("Test — Mozilla Firefox")
            machine.send_key("ctrl-minus")
            machine.send_key("ctrl-minus")
            machine.send_key("alt-f10")
            machine.wait_for_text(r"(Galène|Username|Password|Connect)")
            machine.screenshot("galene-group-test-join")

            # Reload the page, else the stream feed label doesn't show up
            # TODO: figure out why
            machine.send_key("f5")
            machine.sleep(5)

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

  stt = runTest (
    { pkgs, lib, ... }:
    let
      whisperModel = pkgs.galene-stt.passthru.testModel;
      audioSample =
        pkgs.runCommand "test-speech.wav"
          {
            nativeBuildInputs = [ pkgs.flite ];
          }
          ''
            flite -t "Hello world, this is a test." -o "$out"
          '';
      galeneTestGroupBotName = "speech-to-text";
      galeneTestGroupBotPassword = "1234";
      galeneStreamerName = "streamer";
      galeneStreamerPassword = "1234";
      galeneStreamSrtPort = 9710;
    in
    {
      name = "galene-stt-works";
      meta = {
        inherit (pkgs.galene-stt.meta) teams maintainers;
        platforms = lib.platforms.linux;
      };

      nodes.machine =
        { config, pkgs, ... }:
        {
          imports = [ commonService ];

          environment = {
            # https://galene.org/INSTALL.html
            etc.${galeneTestGroupFile}.source = mkGroupConfigFile pkgs {
              op = [
                {
                  username = galeneTestGroupAdminName;
                  password = galeneTestGroupAdminPassword;
                }
                {
                  username = galeneTestGroupBotName;
                  password = galeneTestGroupBotPassword;
                }
              ];
              presenter = [
                {
                  username = galeneStreamerName;
                  password = galeneStreamerPassword;
                }
              ];
              other = [ { } ];
            };

            systemPackages = with pkgs; [
              ffmpeg
              galene-stream
              galene-stt
            ];
          };
        };

      enableOCR = true;
      interactive = interactiveConfig;

      testScript = ''
        machine.wait_for_x()

        ${startGaleneScript}

        ${firefoxLoginScript galeneTestGroupAdminName galeneTestGroupAdminPassword}

        with subtest("galene-stream publishes speech audio"):
            machine.succeed(
                "galene-stream "
                + "--input 'srt://localhost:${toString galeneStreamSrtPort}?mode=listener' "
                + "--insecure --output 'http://localhost:${toString galenePort}/group/test/' "
                + "--username '${galeneStreamerName}' --password '${galeneStreamerPassword}' "
                + " > /tmp/galene-stream.log 2>&1 &"
            )
            machine.wait_until_succeeds("grep -q 'Waiting for incoming stream' /tmp/galene-stream.log", timeout=30)

            # Stream speech audio loop
            machine.succeed(
                "ffmpeg "
                + "-re -stream_loop -1 -i '${audioSample}' "
                + "-f lavfi -i testsrc=size=160x120:rate=10 "
                + "-map 0:a -map 1:v "
                + "-c:a mp2 "
                + "-c:v libx264 -pix_fmt yuv420p "
                + "-f mpegts "
                + "'srt://localhost:${toString galeneStreamSrtPort}' "
                + " > /tmp/ffmpeg.log 2>&1 &"
            )

        with subtest("galene-stt starts and connects"):
            machine.succeed(
                "galene-stt "
                + "-insecure "
                + "-debug "
                + "-caption "
                + "-chat "
                + "-model '${whisperModel}' "
                + "-username '${galeneTestGroupBotName}' "
                + "-password '${galeneTestGroupBotPassword}' "
                + "'http://localhost:${toString galenePort}/group/test/' "
                + " > /tmp/galene-stt.log 2>&1 &"
            )

            # Wait for galene-stt to connect, load the whisper model, and initialize backends without aborting
            machine.wait_until_succeeds("cat /tmp/galene-stt.log >&2; grep -q 'whisper_backend_init:' /tmp/galene-stt.log", timeout=60)
            machine.succeed("pgrep galene-stt")

        with subtest("galene-stt transcribes and displays captions in web UI"):
            # Wait for galene-stt to process audio
            machine.wait_until_succeeds("cat /tmp/galene-stt.log >&2; grep -q 'Processed ' /tmp/galene-stt.log", timeout=60)

            # Wait for caption or chat text to appear on screen in Firefox Web UI
            machine.wait_for_text(r"(this is a test|world|test)")
            machine.screenshot("galene-stt-web-ui")
      '';
    }
  );
}
