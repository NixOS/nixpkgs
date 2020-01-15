import ./make-test.nix ({ pkgs, ... }:

let
  port = 1888;
  username = "mqtt";
  password = "VERY_secret";
  topic = "test/foo";

  cmd = bin: pkgs.lib.concatStringsSep " " [
    "${pkgs.mosquitto}/bin/mosquitto_${bin}"
    "-V mqttv311"
    "-h server"
    "-p ${toString port}"
    "-u ${username}"
    "-P '${password}'"
    "-t ${topic}"
  ];

in {
  name = "mosquitto";
  meta = with pkgs.stdenv.lib; {
    maintainers = with maintainers; [ peterhoeg ];
  };

  nodes = let
    client = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ mosquitto ];
    };
  in {
    server = { pkgs, ... }: {
      networking.firewall.allowedTCPPorts = [ port ];
      services.mosquitto = {
        inherit port;
        enable = true;
        host = "0.0.0.0";
        checkPasswords = true;
        users.${username} = {
          inherit password;
          acl = [
            "topic readwrite ${topic}"
          ];
        };
      };
    };

    client1 = client;
    client2 = client;
  };

  testScript = let
    file = "/tmp/msg";
    sub = args:
      "(${cmd "sub"} -C 1 ${args} | tee ${file} &)";
  in ''
    startAll;
    $server->waitForUnit("mosquitto.service");

    $server->fail("test -f ${file}");
    $client1->fail("test -f ${file}");
    $client2->fail("test -f ${file}");


    # QoS = 0, so only one subscribers should get it
    $server->execute("${sub "-q 0"}");

    # we need to give the subscribers some time to connect
    $client2->execute("sleep 5");
    $client2->succeed("${cmd "pub"} -m FOO -q 0");

    $server->waitUntilSucceeds("grep -q FOO ${file}");
    $server->execute("rm ${file}");


    # QoS = 1, so both subscribers should get it
    $server->execute("${sub "-q 1"}");
    $client1->execute("${sub "-q 1"}");

    # we need to give the subscribers some time to connect
    $client2->execute("sleep 5");
    $client2->succeed("${cmd "pub"} -m BAR -q 1");

    $server->waitUntilSucceeds("grep -q BAR ${file}");
    $server->execute("rm ${file}");

    $client1->waitUntilSucceeds("grep -q BAR ${file}");
    $client1->execute("rm ${file}");
  '';
})
