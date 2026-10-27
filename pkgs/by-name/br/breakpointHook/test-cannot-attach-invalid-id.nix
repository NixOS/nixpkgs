{ attach, runCommand }:
runCommand "cannot_attach_invalid_id" { } ''
  if stderr="$(${attach}/bin/attach 12345768 2>&1 1>/dev/null)"; then
    echo "Test failed, attachment mustn't succeed" 1>&2
    exit 1
  else
    status="$?"
    # The bash 'exit' builtin returns status 2 if the argument is invalid
    if [[ "$status" -ne 1 ]]; then
      echo "Test failed, got unexpected exit code '$status'" 1>&2
      exit 1
    elif [[ "$stderr" == *"Error: No process found for 'sleep 12345768'."* ]]; then
      echo "Test successful" > "$out"
      exit 0
    else
      echo "Test failed" 1>&2
      exit 1
    fi
  fi
''
