{
  curl,
  lib,
  ramalama,
  runCommand,
  writableTmpDirAsHomeHook,
  writeShellScriptBin,
}:

let
  mkServeTestRunner =
    {
      model,
      runtime ? "llama.cpp",
      port,
      host ? "127.0.0.1",
      nocontainer ? false,
      image ? null,
      extraCheck ? "",
    }:

    let
      ramalamaExe = lib.getExe ramalama;
      modelArg = lib.escapeShellArg model;
      serveOptions = lib.concatStringsSep " " (
        [
          # Models and container images are preloaded; serving must stay offline.
          "--pull never"
        ]
        # Nix's macOS builders cannot initialize Metal.
        ++ lib.optional nocontainer ''--runtime-args "--device none"''
        ++ lib.optional (image != null) "--image ${image}"
      );
    in
    writeShellScriptBin "ramalama-serve-test" ''
      set -euo pipefail

      test_store="''${TMPDIR:-/tmp}/store"
      test_log="''${TMPDIR:-/tmp}/ramalama.log"
      test_url="http://127.0.0.1:${toString port}"

      ${ramalamaExe} \
        --store "$test_store" \
        pull \
        ${modelArg}

      ${ramalamaExe} ${lib.optionalString nocontainer "--nocontainer"} \
        --runtime ${runtime} \
        --store "$test_store" \
        serve \
        --host ${host} \
        --port ${toString port} \
        ${serveOptions} \
        ${modelArg} \
        >"$test_log" 2>&1 &
      ramalama_pid=$!
      trap 'kill "$ramalama_pid" 2>/dev/null || true' EXIT

      ready=0
      for _ in {1..120}; do
        if ${lib.getExe curl} --fail --silent --max-time 2 "$test_url/health" >/dev/null 2>&1; then
          ready=1
          break
        fi
        kill -0 "$ramalama_pid" 2>/dev/null || break
        sleep 1
      done

      if (( ! ready )); then
        cat "$test_log"
        exit 1
      fi

      ${extraCheck}

      chat_response=$(
        ${ramalamaExe} --runtime ${runtime} chat \
          --url "$test_url/v1" \
          --max-tokens 16 \
          --temp 0 \
          "Hello"
      )

      if [[ "''${chat_response,,}" != *hello* ]]; then
        echo "chat response did not contain hello:" >&2
        printf '%s\n' "$chat_response" >&2
        exit 1
      fi
    '';
in
{
  inherit mkServeTestRunner;

  mkServeTest =
    {
      name,
      model,
      runtime ? "llama.cpp",
      port,
      setup ? "",
      nocontainer ? false,
    }:

    runCommand name
      {
        nativeBuildInputs = [
          writableTmpDirAsHomeHook
        ];

        __darwinAllowLocalNetworking = true;
      }
      ''
        ${setup}

        ${
          mkServeTestRunner {
            inherit
              model
              runtime
              port
              nocontainer
              ;
          }
        }/bin/ramalama-serve-test

        touch "$out"
      '';
}
