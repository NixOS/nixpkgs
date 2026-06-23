{
  curl,
  jq,
  lib,
  ramalama,
  runCommand,
  writableTmpDirAsHomeHook,
}:

{
  mkServeTest =
    {
      name,
      model,
      runtime,
      port,
      setup ? "",
      globalArgs ? [ ],
      serveArgs ? [ ],
      includeModelInChat ? true,
      timeout ? 120,
      meta ? { },
    }:

    let
      ramalamaCommand = lib.escapeShellArgs (
        [
          "ramalama"
        ]
        ++ globalArgs
        ++ [
          "--runtime"
          runtime
        ]
      );
      serveOptions = lib.escapeShellArgs serveArgs;
    in
    runCommand name
      {
        nativeBuildInputs = [
          curl
          jq
          ramalama
          writableTmpDirAsHomeHook
        ];

        __darwinAllowLocalNetworking = true;

        inherit meta;
      }
      ''
        set -o pipefail

        testRoot="$TMPDIR"

        export OMP_NUM_THREADS=1
        export TMPDIR="$testRoot/tmp"
        mkdir -p "$TMPDIR"

        ${setup}

        port=${toString port}
        ${ramalamaCommand} \
          --store "$TMPDIR/store" \
          serve \
          --host 127.0.0.1 \
          --port "$port" \
          ${
            lib.optionalString (serveArgs != [ ]) ''
              ${serveOptions} \
            ''
          }${lib.escapeShellArg model} \
          >"$TMPDIR/ramalama.log" 2>&1 &
        ramalama_pid=$!
        trap 'kill "$ramalama_pid" 2>/dev/null || true' EXIT

        for _ in $(seq 1 ${toString timeout}); do
          if ! kill -0 "$ramalama_pid" 2>/dev/null; then
            cat "$TMPDIR/ramalama.log"
            exit 1
          fi
          if curl --fail --silent "http://127.0.0.1:$port/health" >/dev/null; then
            break
          fi
          sleep 1
        done

        if ! curl --fail --silent --show-error "http://127.0.0.1:$port/health" >/dev/null; then
          cat "$TMPDIR/ramalama.log"
          exit 1
        fi

        ${lib.optionalString includeModelInChat ''
          model_id=$(
            curl --fail --silent --show-error "http://127.0.0.1:$port/v1/models" \
              | jq --exit-status --raw-output '.data[0].id | select(type == "string" and length > 0)'
          )
        ''}

        chat_payload=$(
          jq --null-input \
            ${lib.optionalString includeModelInChat ''--arg model "$model_id"''} \
            '{
              ${lib.optionalString includeModelInChat "model: $model,"}
              messages: [{role: "user", content: "Say hello"}],
              max_tokens: 16,
              temperature: 0
            }'
        )

        curl --fail --silent --show-error "http://127.0.0.1:$port/v1/chat/completions" \
          --header 'Content-Type: application/json' \
          --data "$chat_payload" \
          | jq --exit-status '
              .choices[0].message.role == "assistant"
              and (.choices[0].message.content | type == "string")
              and (.choices[0].message.content | length > 0)
            ' >/dev/null

        touch "$out"
      '';
}
