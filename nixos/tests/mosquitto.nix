import ./make-test-python.nix ({ pkgs, ... }:

let
  port = 1888;
  username = "mqtt";
  password = "VERY_secret";
  topic = "test/foo";
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
  in ''
    def mosquitto_cmd(binary):
        return (
            "${pkgs.mosquitto}/bin/mosquitto_{} "
            "-V mqttv311 "
            "-h server "
            "-p ${toString port} "
            "-u ${username} "
            "-P '${password}' "
            "-t ${topic}"
        ).format(binary)


    def publish(args):
        return "{} {}".format(mosquitto_cmd("pub"), args)


    def subscribe(args):
        return "({} -C 1 {} | tee ${file} &)".format(mosquitto_cmd("sub"), args)


    start_all()
    server.wait_for_unit("mosquitto.service")

    for machine in server, client1, client2:
        machine.fail("test -f ${file}")

    # QoS = 0, so only one subscribers should get it
    server.execute(subscribe("-q 0"))

    # we need to give the subscribers some time to connect
    client2.execute("sleep 5")
    client2.succeed(publish("-m FOO -q 0"))

    server.wait_until_succeeds("grep -q FOO ${file}")
    server.execute("rm ${file}")

    # QoS = 1, so both subscribers should get it
    server.execute(subscribe("-q 1"))
    client1.execute(subscribe("-q 1"))

    # we need to give the subscribers some time to connect
    client2.execute("sleep 5")
    client2.succeed(publish("-m BAR -q 1"))

    for machine in server, client1:
        machine.wait_until_succeeds("grep -q BAR ${file}")
        machine.execute("rm ${file}")
  '';
})
