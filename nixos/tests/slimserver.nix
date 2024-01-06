import ./make-test-python.nix ({ pkgs, ...} : {
  name = "slimserver";
  meta.maintainers = with pkgs.lib.maintainers; [ adamcstephens ];

  nodes.machine = { ... }: {
    services.slimserver.enable = true;
    services.squeezelite = {
      enable = true;
      extraArguments = "-s 127.0.0.1 -d slimproto=info";
    };
    sound.enable = true;
    boot.initrd.kernelModules = ["snd-dummy"];
  };

  testScript =
    ''
      import json
      rpc_get_player = {
          "id": 1,
          "method": "slim.request",
          "params":[0,["player", "id", "0", "?"]]
      }

      with subtest("slimserver is started"):
          machine.wait_for_unit("slimserver.service")
          # give slimserver a moment to report errors
          machine.sleep(2)

      with subtest('slimserver module errors are not reported'):
          machine.fail("journalctl -u slimserver.service | grep 'throw_exception'")
          machine.fail("journalctl -u slimserver.service | grep 'not installed'")
          machine.fail("journalctl -u slimserver.service | grep 'not found'")
          machine.fail("journalctl -u slimserver.service | grep 'The following CPAN modules were found but cannot work with Logitech Media Server'")
          machine.fail("journalctl -u slimserver.service | grep 'please use the buildme.sh'")

      with subtest('slimserver is ready'):
          machine.wait_for_open_port(9000)
          machine.wait_until_succeeds("journalctl -u slimserver.service | grep 'Completed dbOptimize Scan'")

      with subtest("squeezelite player successfully connects to slimserver"):
          machine.wait_for_unit("squeezelite.service")
          machine.wait_until_succeeds("journalctl -u squeezelite.service | grep -E 'slimproto:[0-9]+ connected'")
          player_mac = machine.wait_until_succeeds("journalctl -eu squeezelite.service | grep -E 'sendHELO:[0-9]+ mac:'").strip().split(" ")[-1]
          player_id = machine.succeed(f"curl http://localhost:9000/jsonrpc.js -g -X POST -d '{json.dumps(rpc_get_player)}'")
          assert player_mac == json.loads(player_id)["result"]["_id"], "squeezelite player not found"
    '';
})
