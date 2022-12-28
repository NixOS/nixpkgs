import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "fluentd";

  nodes.machine = { pkgs, ... }: {
    services.fluentd = {
      enable = true;
      config = ''
        <source>
          @type http
          port 9880
        </source>

        <match **>
          type copy
          <store>
            @type file
            format json
            path /tmp/fluentd
            symlink_path /tmp/current-log
          </store>
          <store>
            @type stdout
          </store>
        </match>
      '';
    };
  };

  testScript = let
    testMessage = "an example log message";

    payload = pkgs.writeText "test-message.json" (builtins.toJSON {
      inherit testMessage;
    });
  in ''
    machine.start()
    machine.wait_for_unit("fluentd.service")
    machine.wait_for_open_port(9880)

    machine.succeed(
        "curl -fsSL -X POST -H 'Content-type: application/json' -d @${payload} http://localhost:9880/test.tag"
    )

    # blocking flush
    machine.succeed("systemctl stop fluentd")

    machine.succeed("grep '${testMessage}' /tmp/current-log")
  '';
})
