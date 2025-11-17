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
          devices = [ "/dev/dri/renderD128" ];
        };
        transcoding = {
          enableToneMapping = false;
          threadCount = 4;
          enableHardwareEncoding = true;
          hardwareDecodingCodecs = [
            "h264"
            "hevc"
          ];
          hardwareEncodingCodecs = [
            "h264"
            "hevc"
          ];
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

      machine.wait_for_unit("jellyfin.service")
      machine.wait_for_open_port(8096)
      machine.wait_until_succeeds("journalctl --since -1m --unit jellyfin --grep 'Startup complete'")
      machine.succeed("curl --fail http://localhost:8096/")

      machine.wait_until_succeeds("curl --fail http://localhost:8096/health | grep Healthy")

      # Test hardware acceleration configuration
      with subtest("Hardware acceleration configuration"):
          machineWithTranscoding.wait_for_unit("jellyfin.service")
          machineWithTranscoding.wait_for_open_port(8096)
          machineWithTranscoding.wait_until_succeeds("journalctl --since -1m --unit jellyfin --grep 'Startup complete'")

          # Check device access
          machineWithTranscoding.succeed("systemctl show jellyfin.service --property=DeviceAllow | grep '/dev/dri/renderD128 rw'")

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
          # Login to get admin token for dashboard API calls
          machineWithTranscoding.wait_until_succeeds(api_get("/Startup/Configuration"))
          machineWithTranscoding.succeed(api_get("/Startup/FirstUser"))
          machineWithTranscoding.succeed(api_post("/Startup/Complete"))
          
          auth_result_str = machineWithTranscoding.succeed(
              api_post("/Users/AuthenticateByName", "${payloads.auth}")
          )
          auth_result = json.loads(auth_result_str)
          auth_token = auth_result["AccessToken"]
          dashboard_auth_header = f'MediaBrowser Client="NixOS Dashboard Tests", DeviceId="dashboard-test", Device="Test Device", Version="1.0", Token={auth_token}'

          def dashboard_api_get(path):
              return f"curl --fail 'http://localhost:8096{path}' -H 'X-Emby-Authorization:{dashboard_auth_header}'"

          # Verify hardware acceleration settings via dashboard API
          encoding_config_str = machineWithTranscoding.succeed(dashboard_api_get("/System/Configuration/encoding"))
          encoding_config = json.loads(encoding_config_str)
          
          # Verify hardware acceleration type
          if encoding_config.get("HardwareAccelerationType") != "vaapi":
              raise Exception(f"Expected HardwareAccelerationType=vaapi, got {encoding_config.get('HardwareAccelerationType')}")
          
          # Verify thread count
          if encoding_config.get("EncodingThreadCount") != 4:
              raise Exception(f"Expected EncodingThreadCount=4, got {encoding_config.get('EncodingThreadCount')}")
          
          # Verify tone mapping is disabled
          if encoding_config.get("EnableTonemapping") != False:
              raise Exception(f"Expected EnableTonemapping=False, got {encoding_config.get('EnableTonemapping')}")
          
          # Verify hardware encoding is enabled
          if encoding_config.get("EnableHardwareEncoding") != True:
              raise Exception(f"Expected EnableHardwareEncoding=True, got {encoding_config.get('EnableHardwareEncoding')}")
          
          # Verify hardware decoding codecs
          expected_decoding_codecs = ["h264", "hevc"]
          actual_decoding_codecs = encoding_config.get("HardwareDecodingCodecs", [])
          if not all(codec in actual_decoding_codecs for codec in expected_decoding_codecs):
              raise Exception(f"Expected decoding codecs {expected_decoding_codecs}, got {actual_decoding_codecs}")
          
          # Verify hardware encoding codecs
          if encoding_config.get("AllowHevcEncoding") != True:
              raise Exception(f"Expected AllowHevcEncoding=True, got {encoding_config.get('AllowHevcEncoding')}")
          
          # Verify CRF values
          if encoding_config.get("H264Crf") != 23:
              raise Exception(f"Expected H264Crf=23, got {encoding_config.get('H264Crf')}")
          
          if encoding_config.get("H265Crf") != 28:
              raise Exception(f"Expected H265Crf=28, got {encoding_config.get('H265Crf')}")

          # Verify subtitle extraction setting
          if encoding_config.get("EnableSubtitleExtraction") != True:
              raise Exception(f"Expected EnableSubtitleExtraction=True, got {encoding_config.get('EnableSubtitleExtraction')}")

          # Verify segment deletion setting
          if encoding_config.get("EnableSegmentDeletion") != True:
              raise Exception(f"Expected EnableSegmentDeletion=True, got {encoding_config.get('EnableSegmentDeletion')}")

          # Verify throttling is disabled
          if encoding_config.get("EnableThrottling") != False:
              raise Exception(f"Expected EnableThrottling=False, got {encoding_config.get('EnableThrottling')}")

          print("All dashboard configuration values verified successfully!")


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
    '';
}
