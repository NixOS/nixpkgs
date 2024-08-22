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
          ExecStart = "${lib.getExe pkgs.ffmpeg-headless} -re -f lavfi -i smptebars=size=1280x720:rate=5 -f mpegts -listen 1 http://0.0.0.0:8080";
          Restart = "always";
        };
      };
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("frigate.service")

    # Frigate startup
    machine.wait_for_open_port(5001)
    machine.wait_until_succeeds("journalctl -u frigate.service -o cat | grep -q 'Created a default user'")

    #machine.log(machine.succeed("curl -vvv --fail http://localhost/api/version")[1])

    machine.wait_for_file("/var/cache/frigate/test@*.mp4")
  '';
})
