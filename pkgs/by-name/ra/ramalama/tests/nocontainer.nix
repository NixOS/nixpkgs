{
  curl,
  fetchurl,
  jq,
  lib,
  ramalama,
  runCommand,
  writableTmpDirAsHomeHook,
}:

let
  model = fetchurl {
    url = "https://huggingface.co/ibm-granite/granite-3.3-2b-instruct-GGUF/resolve/main/granite-3.3-2b-instruct-Q2_K.gguf";
    hash = "sha256-i+Jb5ltKKVV4H9k99R9HUub2/lwDW+pVc7l1OHNt/t0=";
    meta.license = lib.licenses.asl20;
  };
in
runCommand "ramalama-nocontainer-test"
  {
    nativeBuildInputs = [
      curl
      jq
      ramalama
      writableTmpDirAsHomeHook
    ];

    __darwinAllowLocalNetworking = true;
  }
  ''
    set -o pipefail

    testRoot="$TMPDIR"

    export OMP_NUM_THREADS=1
    export TMPDIR="$testRoot/tmp"
    mkdir -p "$TMPDIR"

    port=18080
    ramalama \
      --nocontainer \
      --runtime llama.cpp \
      --store "$TMPDIR/store" \
      pull \
      "file://${model}"

    ramalama \
      --nocontainer \
      --runtime llama.cpp \
      --store "$TMPDIR/store" \
      serve \
      --host 127.0.0.1 \
      --port "$port" \
      --ngl 0 \
      --threads 1 \
      --ctx-size 256 \
      --max-tokens 16 \
      --pull never \
      --temp 0 \
      --thinking off \
      --webui off \
      "file://${model}" \
      >"$TMPDIR/ramalama.log" 2>&1 &
    ramalama_pid=$!
    trap 'kill "$ramalama_pid" 2>/dev/null || true' EXIT

    for _ in $(seq 1 120); do
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

    model_id=$(
      curl --fail --silent --show-error "http://127.0.0.1:$port/v1/models" \
        | jq --exit-status --raw-output '.data[0].id | select(type == "string" and length > 0)'
    )

    curl --fail --silent --show-error "http://127.0.0.1:$port/v1/chat/completions" \
      --header 'Content-Type: application/json' \
      --data "$(jq --null-input \
        --arg model "$model_id" \
        '{model: $model, messages: [{role: "user", content: "Say hello"}], max_tokens: 16, temperature: 0}')" \
      | jq --exit-status '
          .choices[0].message.role == "assistant"
          and (.choices[0].message.content | type == "string")
          and (.choices[0].message.content | length > 0)
        ' >/dev/null

    touch "$out"
  ''
