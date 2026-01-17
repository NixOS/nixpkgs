{ lib, pkgs, ... }:

{
  name = "jellyfin";
  meta.maintainers = with lib.maintainers; [ minijackson ];

  nodes = {
    machine = {
      services.jellyfin.enable = true;
      environment.systemPackages = with pkgs; [ ffmpeg ];
      # Jellyfin fails to start if the data dir doesn't have at least 2GiB of free space
      virtualisation.diskSize = 3 * 1024;
    };

    machineWithTranscoding = {
      services.jellyfin = {
        enable = true;
        hardwareAcceleration = {
          enable = true;
          type = "vaapi";
          device = "/dev/dri/renderD128";
        };
        transcoding = {
          enableToneMapping = false;
          threadCount = 4;
          enableHardwareEncoding = true;
          enableSubtitleExtraction = false;
          deleteSegments = true;
          h264Crf = 23;
          h265Crf = 26;
          throttleTranscoding = false;
          enableIntelLowPowerEncoding = true;
          hardwareDecodingCodecs = {
            h264 = true;
            hevc = true;
            vp9 = true;
            hevcRExt10bit = true;
            hevcRExt12bit = true;
          };
          hardwareEncodingCodecs = {
            hevc = true;
            av1 = true;
          };
        };
      };
      environment.systemPackages = with pkgs; [ ffmpeg ];
      virtualisation.diskSize = 3 * 1024;
    };

    machineWithForceConfig = {
      services.jellyfin = {
        enable = true;
        forceEncodingConfig = true;
        hardwareAcceleration = {
          enable = true;
          type = "vaapi";
          device = "/dev/dri/renderD128";
        };
        transcoding = {
          threadCount = 2;
        };
      };
      environment.systemPackages = with pkgs; [ ffmpeg ];
      virtualisation.diskSize = 3 * 1024;
    };
  };

  # Documentation of the Jellyfin API: https://api.jellyfin.org/
  # Beware, this link can be resource intensive
  testScript =
    let
      payloads = {
        auth = pkgs.writeText "auth.json" (
          builtins.toJSON {
            Username = "jellyfin";
          }
        );
        empty = pkgs.writeText "empty.json" (builtins.toJSON { });
      };
    in
    ''
      import json
      from urllib.parse import urlencode

      def wait_for_jellyfin(machine):
          machine.wait_for_unit("jellyfin.service")
          machine.wait_for_open_port(8096)
          machine.wait_until_succeeds("journalctl --since -1m --unit jellyfin --grep 'Startup complete'")

      wait_for_jellyfin(machine)
      machine.succeed("curl --fail http://localhost:8096/")

      machine.wait_until_succeeds("curl --fail http://localhost:8096/health | grep Healthy")

      # Test hardware acceleration configuration
      with subtest("Hardware acceleration configuration"):
          wait_for_jellyfin(machineWithTranscoding)

          # Check device access
          machineWithTranscoding.succeed("systemctl show jellyfin.service --property=DeviceAllow | grep '/dev/dri/renderD128 rw'")

      # Test forceEncodingConfig backup functionality
      with subtest("Force encoding config creates backup"):
          wait_for_jellyfin(machineWithForceConfig)

          # Verify encoding.xml exists
          machineWithForceConfig.succeed("test -f /var/lib/jellyfin/config/encoding.xml")

          # Stop service before modifying config
          machineWithForceConfig.succeed("systemctl stop jellyfin.service")

          # Create a marker in the current encoding.xml to verify backup works
          machineWithForceConfig.succeed("echo '<!-- MARKER -->' > /var/lib/jellyfin/config/encoding.xml")

          # Restart the service to trigger the backup
          machineWithForceConfig.succeed("systemctl restart jellyfin.service")
          wait_for_jellyfin(machineWithForceConfig)

          # Verify backup was created with the marker (uses glob pattern for timestamped backup)
          machineWithForceConfig.succeed("grep -q 'MARKER' /var/lib/jellyfin/config/encoding.xml.backup-*")

          # Verify the new encoding.xml does not have the marker (was overwritten)
          machineWithForceConfig.fail("grep -q 'MARKER' /var/lib/jellyfin/config/encoding.xml")

      auth_header = 'MediaBrowser Client="NixOS Integration Tests", DeviceId="1337", Device="Apple II", Version="20.09"'


      def api_get(path):
          return f"curl --fail 'http://localhost:8096{path}' -H 'X-Emby-Authorization:{auth_header}'"


      def api_post(path, json_file=None):
          if json_file:
              return f"curl --fail -X post 'http://localhost:8096{path}' -d '@{json_file}' -H Content-Type:application/json -H 'X-Emby-Authorization:{auth_header}'"
          else:
              return f"curl --fail -X post 'http://localhost:8096{path}' -H 'X-Emby-Authorization:{auth_header}'"

      # Test dashboard-based configuration verification
      with subtest("Dashboard configuration verification"):
          # Complete setup and get admin token
          machineWithTranscoding.wait_until_succeeds(api_get("/Startup/Configuration"))
          machineWithTranscoding.succeed(api_get("/Startup/FirstUser"))
          machineWithTranscoding.succeed(api_post("/Startup/Complete"))

          auth_result = json.loads(machineWithTranscoding.succeed(
              api_post("/Users/AuthenticateByName", "${payloads.auth}")
          ))
          token = auth_result["AccessToken"]

          def api_get_with_token(path):
              return f"curl --fail 'http://localhost:8096{path}' -H 'X-Emby-Authorization:MediaBrowser Client=\"Test\", DeviceId=\"test\", Token={token}'"

          # Get encoding config and verify key settings
          config = json.loads(machineWithTranscoding.succeed(api_get_with_token("/System/Configuration/encoding")))

          # Main hardware acceleration settings verification
          assert config.get("HardwareAccelerationType") == "vaapi", f"Hardware acceleration type: expected 'vaapi', got '{config.get('HardwareAccelerationType')}'"
          assert config.get("VaapiDevice") == "/dev/dri/renderD128", f"VAAPI device: expected '/dev/dri/renderD128', got '{config.get('VaapiDevice')}'"
          assert config.get("EncodingThreadCount") == 4, f"Thread count: expected 4, got '{config.get('EncodingThreadCount')}'"
          assert config.get("EnableHardwareEncoding") == True, f"Hardware encoding: expected True, got '{config.get('EnableHardwareEncoding')}'"

          # Transcoding settings verification
          assert config.get("H264Crf") == 23, f"H264 CRF: expected 23, got '{config.get('H264Crf')}'"
          assert config.get("H265Crf") == 26, f"H265 CRF: expected 26, got '{config.get('H265Crf')}'"
          assert config.get("EnableTonemapping") == False, f"Tone mapping: expected False, got '{config.get('EnableTonemapping')}'"
          assert config.get("EnableThrottling") == False, f"Throttling: expected False, got '{config.get('EnableThrottling')}'"
          assert config.get("EnableSubtitleExtraction") == False, f"Subtitle extraction: expected False, got '{config.get('EnableSubtitleExtraction')}'"

          # Hardware encoding codecs verification
          assert config.get("AllowHevcEncoding") == True, f"Allow HEVC encoding: expected True, got '{config.get('AllowHevcEncoding')}'"
          assert config.get("AllowAv1Encoding") == True, f"Allow AV1 encoding: expected True, got '{config.get('AllowAv1Encoding')}'"

          # Intel low power encoding verification
          assert config.get("EnableIntelLowPowerH264HwEncoder") == True, f"Intel low power H264: expected True, got '{config.get('EnableIntelLowPowerH264HwEncoder')}'"
          assert config.get("EnableIntelLowPowerHevcHwEncoder") == True, f"Intel low power HEVC: expected True, got '{config.get('EnableIntelLowPowerHevcHwEncoder')}'"

          # HEVC RExt color depth verification
          assert config.get("EnableDecodingColorDepth10HevcRext") == True, f"HEVC RExt 10bit: expected True, got '{config.get('EnableDecodingColorDepth10HevcRext')}'"
          assert config.get("EnableDecodingColorDepth12HevcRext") == True, f"HEVC RExt 12bit: expected True, got '{config.get('EnableDecodingColorDepth12HevcRext')}'"

          # Hardware decoding codecs verification
          decoding_codecs = config.get("HardwareDecodingCodecs", [])
          assert "h264" in decoding_codecs, f"h264 should be in HardwareDecodingCodecs, got {decoding_codecs}"
          assert "hevc" in decoding_codecs, f"hevc should be in HardwareDecodingCodecs, got {decoding_codecs}"
          assert "vp9" in decoding_codecs, f"vp9 should be in HardwareDecodingCodecs, got {decoding_codecs}"


      with machine.nested("Wizard completes"):
          machine.wait_until_succeeds(api_get("/Startup/Configuration"))
          machine.succeed(api_get("/Startup/FirstUser"))
          machine.succeed(api_post("/Startup/Complete"))

      with machine.nested("Can login"):
          auth_result_str = machine.succeed(
              api_post(
                  "/Users/AuthenticateByName",
                  "${payloads.auth}",
              )
          )
          auth_result = json.loads(auth_result_str)
          auth_token = auth_result["AccessToken"]
          auth_header += f", Token={auth_token}"

          sessions_result_str = machine.succeed(api_get("/Sessions"))
          sessions_result = json.loads(sessions_result_str)

          this_session = [
              session for session in sessions_result if session["DeviceId"] == "1337"
          ]
          if len(this_session) != 1:
              raise Exception("Session not created")

          me_str = machine.succeed(api_get("/Users/Me"))
          me = json.loads(me_str)["Id"]

      with machine.nested("Can add library"):
          tempdir = machine.succeed("mktemp -d -p /var/lib/jellyfin").strip()
          machine.succeed(f"chmod 755 '{tempdir}'")

          # Generate a dummy video that we can test later
          videofile = f"{tempdir}/Big Buck Bunny (2008) [1080p].mkv"
          machine.succeed(f"ffmpeg -f lavfi -i testsrc2=duration=5 '{videofile}'")

          add_folder_query = urlencode(
              {
                  "name": "My Library",
                  "collectionType": "Movies",
                  "paths": tempdir,
                  "refreshLibrary": "true",
              }
          )

          machine.succeed(
              api_post(
                  f"/Library/VirtualFolders?{add_folder_query}",
                  "${payloads.empty}",
              )
          )


      def is_refreshed(_):
          folders_str = machine.succeed(api_get("/Library/VirtualFolders"))
          folders = json.loads(folders_str)
          print(folders)
          return all(folder.get("RefreshStatus") == "Idle" for folder in folders)


      retry(is_refreshed)

      with machine.nested("Can identify videos"):
          items = []

          # For some reason, having the folder refreshed doesn't mean the
          # movie was scanned
          def has_movie(_):
              global items

              items_str = machine.succeed(
                  api_get(f"/Users/{me}/Items?IncludeItemTypes=Movie&Recursive=true")
              )
              items = json.loads(items_str)["Items"]

              return len(items) == 1

          retry(has_movie)

          video = items[0]["Id"]

          item_info_str = machine.succeed(api_get(f"/Users/{me}/Items/{video}"))
          item_info = json.loads(item_info_str)

          if item_info["Name"] != "Big Buck Bunny":
              raise Exception("Jellyfin failed to properly identify file")

      with machine.nested("Can read videos"):
          media_source_id = item_info["MediaSources"][0]["Id"]

          machine.succeed(
              "ffmpeg"
              + f" -headers 'X-Emby-Authorization:{auth_header}'"
              + f" -i http://localhost:8096/Videos/{video}/master.m3u8?mediaSourceId={media_source_id}"
              + " /tmp/test.mkv"
          )

          duration = machine.succeed(
              "ffprobe /tmp/test.mkv"
              + " -show_entries format=duration"
              + " -of compact=print_section=0:nokey=1"
          )

          if duration.strip() != "5.000000":
              raise Exception("Downloaded video has wrong duration")

      machine.log(machine.succeed("systemd-analyze security jellyfin.service | grep -v '✓'"))
    '';
}
