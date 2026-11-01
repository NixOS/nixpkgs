{ lib, pkgs, ... }:

{
  name = "ersatztv";
  meta.maintainers = with lib.maintainers; [
    allout58
    font44
  ];

  nodes.basic =
    { ... }:
    {
      services.ersatztv.enable = true;
      environment.systemPackages = [
        pkgs.ffmpeg
        pkgs.jq
      ];
    };
  nodes.reconfigured =
    { ... }:
    {
      services.ersatztv.enable = true;
      services.ersatztv.environment.ETV_UI_PORT = 8123;
      services.ersatztv.openFirewall = true;
      environment.systemPackages = [ pkgs.jq ];
    };

  # ErsatzTV doesn't really have an API to speak of currently, so just check if it responds at all
  testScript =
    { nodes, ... }:
    let
      basicIp = (lib.head nodes.basic.networking.interfaces.eth1.ipv4.addresses).address;
      reconfiguredIp = (lib.head nodes.reconfigured.networking.interfaces.eth1.ipv4.addresses).address;
      next = pkgs.ersatztv-next;
    in
    ''
      def api_key(machine):
          return machine.wait_until_succeeds(
              "jq -er .ApiKey /var/lib/ersatztv/config/api-secrets.json"
          ).strip()

      def api_get(url, key):
          return f"curl --fail -H 'X-Etv-Api-Key: {key}' {url}"

      start_all()
      basic.wait_for_unit("ersatztv.service")
      basic.wait_for_open_port(8409)
      basic_key = api_key(basic)
      basic.succeed(api_get("http://localhost:8409/api/sessions", basic_key))

      with subtest("ErsatzTV finds the Next streaming engine"):
          # ErsatzTV logs "n/a" when it can't run ersatztv-channel
          basic.wait_until_succeeds(
              "journalctl -u ersatztv.service | grep 'ErsatzTV Next version ${next.version}'"
          )

      with subtest("ErsatzTV Next serves a channel standalone"):
          basic.succeed(
              "mkdir -p /tmp/next/videos",
              "ffmpeg -loglevel error -f lavfi -i testsrc2=duration=10:size=640x360:rate=30"
              + " -f lavfi -i sine=frequency=440:duration=10 -c:v libx264 -c:a aac -shortest"
              + " /tmp/next/videos/test.mp4",
              "${lib.getExe next} add-lineup /tmp/next/config/lineup.json --channels 1",
              "sed -i 's/\"0.0.0.0\"/\"127.0.0.1\"/; s/8409/8410/' /tmp/next/config/lineup.json",
              # the default 1080p output is slow to transcode without KVM
              "jq '.normalization.video.width = 640 | .normalization.video.height = 360'"
              + " /tmp/next/config/channels/1/channel.json > /tmp/next/channel.json",
              "mv /tmp/next/channel.json /tmp/next/config/channels/1/channel.json",
              "${next}/bin/ersatztv-playout-generator --lineup /tmp/next/config/lineup.json"
              + " --channel 1 --content-folder /tmp/next/videos",
          )
          basic.succeed("systemd-run --unit ersatztv-next ${lib.getExe next} /tmp/next/config/lineup.json")
          basic.wait_for_open_port(8410)
          basic.succeed("curl --fail http://127.0.0.1:8410/channels.m3u | grep -F 'channel/1.m3u8'")
          basic.succeed("curl --fail http://127.0.0.1:8410/xmltv.xml | grep -F '<title>test</title>'")
          # the first request starts the channel; it answers 503 until the first segments exist
          basic.wait_until_succeeds("curl --fail http://127.0.0.1:8410/channel/1.m3u8", timeout=600)
          segment = basic.wait_until_succeeds(
              "curl --fail http://127.0.0.1:8410/session/1/live.m3u8 | grep -m1 '\\.ts$'"
          ).strip()
          basic.succeed(f"curl --fail -o /tmp/next/segment.ts http://127.0.0.1:8410/session/1/{segment}")
          basic.succeed("ffprobe -v error -select_streams v:0 -show_entries stream=codec_name /tmp/next/segment.ts | grep h264")

      reconfigured.wait_for_unit("ersatztv.service")
      reconfigured.wait_for_open_port(8123)
      reconfigured_key = api_key(reconfigured)
      reconfigured.succeed(api_get("http://localhost:8123/api/sessions", reconfigured_key))

      # Test that the firewall is open
      reconfigured.fail(
          api_get("--connect-timeout 5 http://${basicIp}:8409/api/sessions", basic_key)
      )
      basic.succeed(api_get("http://${reconfiguredIp}:8123/api/sessions", reconfigured_key))
    '';
}
