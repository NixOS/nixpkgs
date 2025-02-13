import ./make-test-python.nix (
  { pkgs, ... }:
  let
    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.croc ];
      };
    pass = "PassRelay";
  in
  {
    name = "croc";
    meta = with pkgs.lib.maintainers; {
      maintainers = [
        equirosa
        SuperSandro2000
      ];
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
          "env CROC_SECRET=topSecret croc --pass ${pass} --relay relay send testfile01.txt testfile02.txt >&2 &"
      )

      # receive the testfiles and check them
      receiver.succeed(
          "env CROC_SECRET=topSecret croc --pass ${pass} --yes --relay relay"
      )
      assert "Hello World" in receiver.succeed("cat testfile01.txt")
      assert "Hello Earth" in receiver.succeed("cat testfile02.txt")
    '';
  }
)
