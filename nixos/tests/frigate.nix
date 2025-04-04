{
  pkgs,
  lib,
  ...
}:

{
  name = "frigate";
  meta = { inherit (pkgs.frigate.meta) maintainers; };

  nodes = {
    machine = {
      services.frigate = {
        enable = true;

        hostname = "localhost";

        settings = {
          mqtt.enabled = false;

          cameras.test = {
            ffmpeg = {
              input_args = "-fflags nobuffer -strict experimental -fflags +genpts+discardcorrupt -r 10 -use_wallclock_as_timestamps 1";
              inputs = [
                {
                  path = "http://127.0.0.1:8080";
                  roles = [
                    "record"
                  ];
                }
              ];
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

      environment.systemPackages = with pkgs; [ httpie ];
    };
  };

  testScript = ''
    start_all()

    # wait until frigate is up
    machine.wait_for_unit("frigate.service")
    machine.wait_for_open_port(5001)

    # extract admin password from logs
    machine.wait_until_succeeds("journalctl -u frigate.service -o cat | grep -q 'Password: '")
    password = machine.execute("journalctl -u frigate.service -o cat | grep -oP '([a-f0-9]{32})'")[1]

    # login and store session
    machine.log(machine.succeed(f"http --check-status --session=frigate post http://localhost/api/login user=admin password={password}"))

    # make authenticated api request
    machine.log(machine.succeed("http --check-status --session=frigate get http://localhost/api/version"))

    # make unauthenticated api request
    machine.log(machine.succeed("http --check-status get http://localhost:5000/api/version"))

    # wait for a recording to appear
    machine.wait_for_file("/var/cache/frigate/test@*.mp4")
  '';
}
