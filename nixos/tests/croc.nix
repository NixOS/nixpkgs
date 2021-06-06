import ./make-test-python.nix ({ pkgs, ... }:
let
  client = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.croc ];
  };
  pass = pkgs.writeText "pass" "PassRelay";
in {
  name = "croc";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ hax404 julm ];
  };

  nodes = {
    relay = {
      services.croc = {
        enable = true;
        pass = pass;
        openFirewall = true;
      };
    };
    sender = client;
    receiver = client;
  };

  testScript = ''
    start_all()

    # wait until relay is up
    relay.wait_for_unit("croc")
    relay.wait_for_open_port(9009)
    relay.wait_for_open_port(9010)
    relay.wait_for_open_port(9011)
    relay.wait_for_open_port(9012)
    relay.wait_for_open_port(9013)

    # generate testfiles and send them
    sender.wait_for_unit("multi-user.target")
    sender.execute("echo Hello World > testfile01.txt")
    sender.execute("echo Hello Earth > testfile02.txt")
    sender.execute(
        "croc --pass ${pass} --relay relay send --code topSecret testfile01.txt testfile02.txt &"
    )

    # receive the testfiles and check them
    receiver.succeed(
        "croc --pass ${pass} --yes --relay relay topSecret"
    )
    assert "Hello World" in receiver.succeed("cat testfile01.txt")
    assert "Hello Earth" in receiver.succeed("cat testfile02.txt")
  '';
})
