import ../make-test-python.nix ({ pkgs, ... }:
  {
    name = "stratis";

    meta = with pkgs.lib.maintainers; {
      maintainers = [ nickcao ];
    };

    nodes.machine = { pkgs, ... }: {
      services.stratis.enable = true;
      virtualisation.emptyDiskImages = [ 2048 ];
    };

    testScript =
      let
        testkey1 = pkgs.writeText "testkey1" "supersecret1";
        testkey2 = pkgs.writeText "testkey2" "supersecret2";
      in
      ''
        machine.wait_for_unit("stratisd")
        # test creation of encrypted pool and filesystem
        machine.succeed("stratis key  set    testkey1  --keyfile-path ${testkey1}")
        machine.succeed("stratis key  set    testkey2  --keyfile-path ${testkey2}")
        machine.succeed("stratis pool create testpool /dev/vdb --key-desc testkey1")
        machine.succeed("stratis fs   create testpool testfs")
        # test rebinding encrypted pool
        machine.succeed("stratis pool rebind keyring  testpool testkey2")
        # test restarting encrypted pool
        machine.succeed("stratis pool stop   testpool")
        machine.succeed("stratis pool start  --name testpool --unlock-method keyring")
      '';
  })
