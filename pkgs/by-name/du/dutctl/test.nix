{
  runCommand,
  writeScriptBin,
  expect,

  dutctl,
}:
let
  dutctl-test =
    runCommand "test-dutctl-basic"
      {
        nativeBuildInputs = [
          dutctl
          interactive-repeat-test
        ];
      }
      ''
        cfg="${dutctl.src}/contrib/dutagent-cfg-example.yaml"

        # start agent
        dutagent -a localhost:1024 -c "$cfg" &
        agent_pid=$!
        trap 'kill "$agent_pid" 2>/dev/null || true' EXIT

        # wait for agent to become ready
        for i in $(seq 1 10); do
          dutctl list 2>/dev/null | grep -q device1 && break
          [ "$i" -eq 10 ] && { echo "FAIL: agent timed out"; exit 1; }
          sleep 1
        done
        echo "PASS: agent ready"

        # verify device status
        dutctl device1 status > status.out
        grep -q "Hello from dummy status module" status.out
        echo "PASS: device1 status"

        # run interactive repeat test
        repeat-test

        touch $out
      '';

  interactive-repeat-test = writeScriptBin "repeat-test" ''
    #!${expect}/bin/expect -f

    spawn dutctl device2 repeat

    expect {
      "Hello from dummy repeat module!" {}
      timeout { puts "FAIL: no greeting"; exit 1 }
    }

    send "hello\r"
    expect {
      "hello" {}
      timeout { puts "FAIL: no echo"; exit 1 }
    }

    send "stop now\r"
    expect {
      "Oh no! Can only handle one word per line." {}
      timeout { puts "FAIL: no termination msg"; exit 1 }
    }

    # wait for the process to finish and collect its exit code
    expect eof
    lassign [wait] pid spawnid os_error exit_code

    if {$exit_code != 0} {
      puts "FAIL: exit $exit_code"
      exit 1
    }

    puts "PASS: interactive repeat"
  '';
in
dutctl-test
