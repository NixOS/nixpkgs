{
  curl,
  dockerTools,
  fetchurl,
  jq,
  lib,
  ramalama,
  stdenv,
  testers,
}:

let
  imageInfo = builtins.fromJSON (builtins.readFile ./podman-images.json);

  imageName = imageInfo.imageName;
  pinnedImageTag = imageInfo.imageTag;
  packageImageTag = lib.versions.majorMinor ramalama.version;

  imagePin =
    imageInfo.images.${stdenv.hostPlatform.system}
      or (throw "ramalama podman test is not supported on ${stdenv.hostPlatform.system}");

  ramalamaImage = dockerTools.pullImage {
    inherit imageName;
    inherit (imageInfo) imageDigest;
    inherit (imagePin) hash arch;
    os = "linux";
    finalImageName = imageName;
    finalImageTag = pinnedImageTag;
  };

  modelArg = "file://${modelFile}";
  modelFile = fetchurl {
    url = "https://huggingface.co/ibm-granite/granite-3.3-2b-instruct-GGUF/resolve/main/granite-3.3-2b-instruct-Q2_K.gguf";
    hash = "sha256-i+Jb5ltKKVV4H9k99R9HUub2/lwDW+pVc7l1OHNt/t0=";
    meta.license = lib.licenses.asl20;
  };

  port = 18082;
in

assert lib.assertMsg (packageImageTag == pinnedImageTag) ''
  ramalama podman test image pin is for ${imageName}:${pinnedImageTag}, but
  ramalama ${ramalama.version} uses ${imageName}:${packageImageTag}; update the
  pinned image metadata in tests/podman-images.json.
'';

testers.runNixOSTest {
  name = "ramalama-podman-test";

  meta.platforms = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  nodes.machine =
    { ... }:
    {
      virtualisation = {
        cores = 2;
        # Podman expands the pinned image under /var/lib/containers/storage.
        diskSize = 10 * 1024;
        memorySize = 4096;
        podman.enable = true;
      };

      environment.systemPackages = [
        curl
        jq
        ramalama
      ];
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("podman load -i ${ramalamaImage}")
    machine.succeed("podman image exists ${imageName}:${pinnedImageTag}")
    machine.succeed("mkdir -p /var/lib/ramalama-test")
    machine.succeed("ramalama --runtime llama.cpp --store /var/lib/ramalama-test pull ${lib.escapeShellArg modelArg}")

    machine.succeed("""
      set -o pipefail
      ramalama \\
        --runtime llama.cpp \\
        --store /var/lib/ramalama-test \\
        serve \\
        --device none \\
        --image ${imageName}:${pinnedImageTag} \\
        --pull never \\
        --host 0.0.0.0 \\
        --port ${toString port} \\
        --max-tokens 16 \\
        --temp 0 \\
        --ngl 0 \\
        ${lib.escapeShellArg modelArg} \\
        >/tmp/ramalama.log 2>&1 &
      echo "$!" >/tmp/ramalama.pid
    """)

    machine.succeed("""
      for _ in $(seq 1 120); do
        if ! kill -0 "$(cat /tmp/ramalama.pid)" 2>/dev/null; then
          cat /tmp/ramalama.log
          exit 1
        fi
        if curl --fail --silent http://127.0.0.1:${toString port}/health >/dev/null; then
          exit 0
        fi
        sleep 1
      done
      cat /tmp/ramalama.log
      exit 1
    """)

    machine.succeed("podman ps --format '{{.Image}}' | grep -F ${lib.escapeShellArg "${imageName}:${pinnedImageTag}"}")

    machine.succeed("""
      model_id=$(
        curl --fail --silent --show-error http://127.0.0.1:${toString port}/v1/models \\
          | jq --exit-status --raw-output '.data[0].id | select(type == "string" and length > 0)'
      )

      jq --null-input --arg model "$model_id" '{
        model: $model,
        messages: [{role: "user", content: "Say hello"}],
        max_tokens: 16,
        temperature: 0
      }' >/tmp/chat-payload.json

      curl --fail --silent --show-error http://127.0.0.1:${toString port}/v1/chat/completions \\
        --header 'Content-Type: application/json' \\
        --data @/tmp/chat-payload.json \\
        | jq --exit-status '
            .choices[0].message.role == "assistant"
            and (.choices[0].message.content | type == "string")
            and (.choices[0].message.content | length > 0)
          ' >/dev/null
    """)
  '';
}
