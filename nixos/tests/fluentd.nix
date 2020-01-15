import ./make-test.nix ({ pkgs, lib, ... }: {
  name = "fluentd";

  machine = { pkgs, ... }: {
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
    $machine->start;
    $machine->waitForUnit('fluentd.service');
    $machine->waitForOpenPort(9880);

    $machine->succeed("curl -fsSL -X POST -H 'Content-type: application/json' -d @${payload} http://localhost:9880/test.tag");

    $machine->succeed("systemctl stop fluentd"); # blocking flush

    $machine->succeed("grep '${testMessage}' /tmp/current-log");
  '';
})
