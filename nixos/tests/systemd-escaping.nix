import ./make-test-python.nix ({ pkgs, ... }:

let
  echoAll = pkgs.writeScript "echo-all" ''
    #! ${pkgs.runtimeShell}
    for s in "$@"; do
      printf '%s\n' "$s"
    done
  '';
  # deliberately using a local empty file instead of pkgs.emptyFile to have
  # a non-store path in the test
  args = [ "a%Nything" "lang=\${LANG}" ";" "/bin/sh -c date" ./empty-file 4.2 23 ];

  testPaths = [
    "/"
    "/dev/input/event0"
    "/home/user/My Documents"
    "/sys/devices/pci0000:00/0000:00:14.0/usb3/3-9/3-9.3/3-9.3.2/3-9.3.2.3/3-9.3.2.3:1.0/0003:3297:4976.0030/input/input71/event23"
    "/mnt/2+2"
    "/mnt/result=4"
    "/usr/bin/pg_dump"
    "/tmp/"
    "/.Trash-1000"
    # systemd-escape -p warns that this path can't be reversed, but it's still valid input
    ""
    # # Test disabled: result should be home-p\xc3\xb6ttering
    # "/home/pöttering"
    # # Test disabled: result should be tmp-waldi-foobar
    # "/tmp//waldi/foobar/"
  ];
in
{
  name = "systemd-escaping";

  nodes.machine = { pkgs, lib, utils, ... }: {
    systemd.services.echo =
      assert !(builtins.tryEval (utils.escapeSystemdExecArgs [ [] ])).success;
      assert !(builtins.tryEval (utils.escapeSystemdExecArgs [ {} ])).success;
      assert !(builtins.tryEval (utils.escapeSystemdExecArgs [ null ])).success;
      assert !(builtins.tryEval (utils.escapeSystemdExecArgs [ false ])).success;
      assert !(builtins.tryEval (utils.escapeSystemdExecArgs [ (_:_) ])).success;
      { description = "Echo to the journal";
        serviceConfig.Type = "oneshot";
        serviceConfig.ExecStart = ''
          ${echoAll} ${utils.escapeSystemdExecArgs args}
        '';
      };

    systemd.services.echo-paths =
      assert !(builtins.tryEval (utils.escapeSystemdPath null)).success;
      { description = "Echo path test results to the journal";
        serviceConfig.Type = "oneshot";
        script = lib.concatImapStringsSep "\n"
          (i: path: ''
            printf 'test ${toString i}:\t%s\n' '${path}'
            printf 'expect:\t%s\n' $(2>/dev/null ${pkgs.systemd}/bin/systemd-escape -p '${path}')
            printf 'actual:\t%s\n' '${utils.escapeSystemdPath path}'
          '') testPaths;
      };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    machine.succeed("systemctl start echo.service")
    # skip the first 'Starting <service> ...' line
    logs = machine.succeed("journalctl -u echo.service -o cat").splitlines()[1:]
    assert "a%Nything" == logs[0]
    assert "lang=''${LANG}" == logs[1]
    assert ";" == logs[2]
    assert "/bin/sh -c date" == logs[3]
    assert "/nix/store/ij3gw72f4n5z4dz6nnzl1731p9kmjbwr-empty-file" == logs[4]
    assert "4.2" in logs[5] # toString produces extra fractional digits!
    assert "23" == logs[6]

    machine.succeed("systemctl start echo-paths.service")
    num_tests = ${toString (builtins.length testPaths)}
    # skip the first 'Starting <service> ...' line
    logs = machine.succeed("journalctl -u echo-paths.service -o cat").splitlines()[1:]
    # for each group of 3 log lines make a dictionary of test/expected/actual
    results = [dict(tuple(log.split(":", 1)) for log in logs[i:i+3]) for i in range(0, num_tests*3, 3)]
    assert len(results) == num_tests, "Incorrect number of test results found in journal"
    # test actual == expected for each test case
    for result in results:
        assert result["actual"] == result["expect"], "Expected {expect}, got {actual}".format(**result)
  '';
})
