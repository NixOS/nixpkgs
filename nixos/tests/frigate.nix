import ./make-test-python.nix ({ pkgs, lib, ...} :

{
  name = "frigate";
  meta.maintainers = with lib.maintainers; [ hexa ];

  nodes = {
    machine = { config, ... }: {
      services.frigate = {
        enable = true;

        hostname = "localhost";

        settings = {
          mqtt.enabled = false;

          cameras.test = {
            ffmpeg = {
              input_args = "-fflags nobuffer -strict experimental -fflags +genpts+discardcorrupt -r 10 -use_wallclock_as_timestamps 1";
              inputs = [ {
                path = "http://127.0.0.1:8080";
                roles = [
                  "record"
                ];
              } ];
            };
          };

          record.enabled = true;
        };
      };

      systemd.services.video-stream = {
        description = "Start a test stream that frigate can capture";
        before = [
          "frigate.service"
        ];
        wantedBy = [
          "multi-user.target"
        ];
        serviceConfig = {
          DynamicUser = true;
          ExecStart = "${lib.getBin pkgs.ffmpeg-headless}/bin/ffmpeg -re -f lavfi -i smptebars=size=800x600:rate=10 -f mpegts -listen 1 http://0.0.0.0:8080";
        };
      };
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("frigate.service")

    machine.wait_for_open_port(5001)

    machine.succeed("curl http://localhost:5001")

    machine.wait_for_file("/var/cache/frigate/test-*.mp4")
  '';
})
