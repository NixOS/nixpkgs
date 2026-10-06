{ attach, runCommand }:
runCommand "can_attach_valid_id" { } ''
  # The `sleep` provided by coreutils apparently ignores all signals. So
  # even when it's killed, it will delay execution for the entire defined
  # interval. Hence, we should keep the interval low here.
  coproc child { sleep 6; }

  function _exit_5 {
    exit 5
  }
  export debugShell="_exit_5"

  if stderr="$(${attach}/bin/attach 6 2>&1 1>/dev/null)"; then
    kill -KILL "$child_PID"
    echo "invalid process attachment succeeded, probably for an unrelated process" 1>&2
    exit 1
  else
    status="$?"
    kill -KILL "$child_PID"
    echo "$stderr"
    case "$status" in
      5)
        echo "Test successful" > "$out"
        exit 0
        ;;
      *)
        if [[ "$stderr" == *"nsenter: reassociate to namespaces failed"* ]]; then
          # Executing `nsenter` probably requires root privileges
          # everywhere, so this is expected to fail. But, if it gets to
          # executing `nsenter` in the first place, the attach was pretty
          # much successful.
          echo "Test successful" > "$out"
          exit 0
        else
          echo "Test failed"
          exit 1
        fi
        ;;
    esac
  fi
''
