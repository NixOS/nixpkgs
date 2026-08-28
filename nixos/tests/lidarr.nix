{ pkgs, lib, ... }:

let
in
{
  name = "lidarr";
  meta.maintainers = [ lib.maintainers.h7x4 ];

  nodes = {
    tracker = {
      imports = [ ./common/torrent-tracker.nix ];
      test-support.torrentTracker = {
        enable = true;
        torrents."track.flac".file = pkgs.writeText "track.flac" "not actually a flac, just test content";
      };
    };

    machine = {
      services.lidarr.enable = true;
      services.transmission.enable = true;
      environment.systemPackages = [ pkgs.yq-go ];
    };
  };

  testScript =
    { nodes, ... }:
    let
      trackName = "track.flac";
      trackFile = nodes.tracker.test-support.torrentTracker.torrents."track.flac".file;
      torrentUrl = nodes.tracker.test-support.torrentTracker.torrents."track.flac".url;

      trackerPort = nodes.tracker.test-support.torrentTracker.trackerPort;
      lidarrPort = nodes.machine.services.lidarr.settings.server.port;
      transmissionPort = nodes.machine.services.transmission.settings.rpc-port;
      lidarrConfigFile = "${nodes.machine.services.lidarr.dataDir}/config.xml";
      transmissionCategoryDir = "${nodes.machine.services.transmission.settings.download-dir}/lidarr";
      transmissionDownload = "${transmissionCategoryDir}/${trackName}";

      jsonFile = (pkgs.formats.json { }).generate;
    in
    ''
      import json


      def lidarr_api(method, path, json_file=None):
          command = (
              f"curl --fail -sS -X {method} http://localhost:${toString lidarrPort}{path}"
              f" -H 'X-Api-Key: {api_key}'"
          )
          if json_file is not None:
              command += f" --json @{json_file}"
          return json.loads(machine.succeed(command))

      start_all()

      tracker.wait_for_unit("torrent-tracker.target")
      tracker.wait_for_open_port(${toString trackerPort})

      machine.wait_for_unit("lidarr.service")
      machine.wait_for_open_port(${toString lidarrPort})
      machine.succeed("curl --fail http://localhost:${toString lidarrPort}/")
      api_key = machine.succeed(
          "yq -p xml -oy '.Config.ApiKey' ${lidarrConfigFile}"
      ).strip()

      machine.wait_for_unit("transmission.service")
      machine.wait_for_open_port(${toString transmissionPort})

      with subtest("Configure with a transmission as a download client"):
          response = lidarr_api(
              "POST",
              "/api/v1/downloadclient",
              "${
                # https://lidarr.audio/docs/api/#/DownloadClient/post_api_v1_downloadclient
                jsonFile "lidarr-download-client.json" {
                  enable = true;
                  protocol = "torrent";
                  priority = 1;
                  name = "Transmission";
                  implementation = "Transmission";
                  implementationName = "Transmission";
                  configContract = "TransmissionSettings";
                  fields = [ ];
                }
              }",
          )
          assert "id" in response

      with subtest("Have transmission fetch a release from the tracker"):
          machine.succeed("transmission-remote --add ${torrentUrl} --download-dir ${transmissionCategoryDir}")
          machine.wait_for_file("${transmissionDownload}")
          machine.succeed("cmp ${transmissionDownload} ${trackFile}")

      with subtest("Lidarr's queue reports the download"):
          lidarr_api(
              "POST",
              "/api/v1/command",
              "${jsonFile "lidarr-refresh-downloads.json" { name = "RefreshMonitoredDownloads"; }}",
          )

          def download_in_queue(_last_try):
              queue = lidarr_api("GET", "/api/v1/queue?includeUnknownArtistItems=true")
              return any(record["downloadClient"] == "Transmission" for record in queue["records"])

          retry(download_in_queue)
    '';
}
