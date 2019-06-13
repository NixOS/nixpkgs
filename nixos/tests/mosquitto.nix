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

in rec {
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
        users."${username}" = {
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
    payload = "wootWOOT";
  in ''
    startAll;
    $server->waitForUnit("mosquitto.service");

    $server->fail("test -f ${file}");
    $server->execute("(${cmd "sub"} -C 1 | tee ${file} &)");

    $client1->fail("test -f ${file}");
    $client1->execute("(${cmd "sub"} -C 1 | tee ${file} &)");

    $client2->succeed("${cmd "pub"} -m ${payload}");

    $server->succeed("grep -q ${payload} ${file}");

    $client1->succeed("grep -q ${payload} ${file}");
  '';
})
