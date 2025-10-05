{ pkgs, lib, ... }:

let
  rtmpUrl = "rtmp://localhost:1935/test";
in
{
  name = "mediamtx";
  meta.maintainers = with lib.maintainers; [ fpletz ];

  nodes = {
    machine = {
      services.mediamtx = {
        enable = true;
        settings = {
          metrics = true;
          paths.all.source = "publisher";
        };
      };

      systemd.services.rtmp-publish = {
        description = "Publish an RTMP stream to mediamtx";
        after = [ "mediamtx.service" ];
        bindsTo = [ "mediamtx.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          DynamicUser = true;
          Restart = "on-failure";
          RestartSec = "1s";
          TimeoutStartSec = "30s";
          ExecStart = "${lib.getBin pkgs.ffmpeg-headless}/bin/ffmpeg -re -f lavfi -i smptebars=size=800x600:rate=10 -c libx264 -f flv ${rtmpUrl}";
        };
      };

      systemd.services.rtmp-receive = {
        description = "Receive an RTMP stream from mediamtx";
        after = [ "rtmp-publish.service" ];
        bindsTo = [ "rtmp-publish.service" ];
        wantedBy = [ "multi-user.target" ];
        unitConfig.StartLimitIntervalSec = 0;
        serviceConfig = {
          DynamicUser = true;
          Restart = "on-failure";
          RestartSec = "1s";
          TimeoutStartSec = "30s";
          ExecStart = "${lib.getBin pkgs.ffmpeg-headless}/bin/ffmpeg -y -re -i ${rtmpUrl} -f flv /dev/null";
        };
      };
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("mediamtx.service")

    machine.wait_for_unit("rtmp-publish.service")
    machine.wait_until_succeeds("curl http://localhost:9998/metrics | grep '^rtmp_conns.*state=\"publish\".*1$'")

    machine.wait_for_unit("rtmp-receive.service")
    machine.wait_until_succeeds("curl http://localhost:9998/metrics | grep '^rtmp_conns.*state=\"read\".*1$'")
  '';
}
