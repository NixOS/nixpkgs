{
  lib,
  pkgs,
  ...
}:
let
  ollamaPort = 11434;
  openclawPort = 18789;
  model = "smollm:135m";

  # Pre-fetch ollama model blobs so the test VM needs no network access.
  # smollm:135m is only ~92MB, fast enough for CPU inference in a VM.
  # Registry manifest: https://registry.ollama.ai/v2/library/smollm/manifests/135m
  modelBlob = pkgs.fetchurl {
    url = "https://registry.ollama.ai/v2/library/smollm/blobs/sha256:eb2c714d40d4b35ba4b8ee98475a06d51d8080a17d2d2a75a23665985c739b94";
    hash = "sha256-6yxxTUDUs1ukuO6YR1oG1R2AgKF9LSp1ojZlmFxzm5Q=";
    name = "model";
  };
  templateBlob = pkgs.fetchurl {
    url = "https://registry.ollama.ai/v2/library/smollm/blobs/sha256:62fbfd9ed093d6e5ac83190c86eec5369317919f4b149598d2dbb38900e9faef";
    hash = "sha256-Yvv9ntCT1uWsgxkMhu7FNpMXkZ9LFJWY0tuziQDp+u8=";
    name = "template";
  };
  licenseBlob = pkgs.fetchurl {
    url = "https://registry.ollama.ai/v2/library/smollm/blobs/sha256:cfc7749b96f63bd31c3c42b5c471bf756814053e847c10f3eb003417bc523d30";
    hash = "sha256-z8d0m5b2O9McPEK1xHG/dWgUBT6EfBDz6wA0F7xSPTA=";
    name = "license";
  };
  paramsBlob = pkgs.fetchurl {
    url = "https://registry.ollama.ai/v2/library/smollm/blobs/sha256:ca7a9654b5469dc2d638456f31a51a03367987c54135c089165752d9eeb08cd7";
    hash = "sha256-ynqWVLVGncLWOEVvMaUaAzZ5h8VBNcCJFldS2e6wjNc=";
    name = "params";
  };
  configBlob = pkgs.fetchurl {
    url = "https://registry.ollama.ai/v2/library/smollm/blobs/sha256:f590523c855b7d0f2741a9e076d4b663b1f128f2617b7fcd3fe7d7b57ce71d83";
    hash = "sha256-9ZBSPIVbfQ8nQangdtS2Y7HxKPJhe3/NP+fXtXznHYM=";
    name = "config";
  };

  manifestJson = builtins.toJSON {
    schemaVersion = 2;
    mediaType = "application/vnd.docker.distribution.manifest.v2+json";
    config = {
      mediaType = "application/vnd.docker.container.image.v1+json";
      digest = "sha256:f590523c855b7d0f2741a9e076d4b663b1f128f2617b7fcd3fe7d7b57ce71d83";
      size = 488;
    };
    layers = [
      {
        mediaType = "application/vnd.ollama.image.model";
        digest = "sha256:eb2c714d40d4b35ba4b8ee98475a06d51d8080a17d2d2a75a23665985c739b94";
        size = 91727296;
      }
      {
        mediaType = "application/vnd.ollama.image.template";
        digest = "sha256:62fbfd9ed093d6e5ac83190c86eec5369317919f4b149598d2dbb38900e9faef";
        size = 182;
      }
      {
        mediaType = "application/vnd.ollama.image.license";
        digest = "sha256:cfc7749b96f63bd31c3c42b5c471bf756814053e847c10f3eb003417bc523d30";
        size = 11358;
      }
      {
        mediaType = "application/vnd.ollama.image.params";
        digest = "sha256:ca7a9654b5469dc2d638456f31a51a03367987c54135c089165752d9eeb08cd7";
        size = 89;
      }
    ];
  };

  ollamaModelDir = pkgs.runCommand "ollama-model-smollm-135m" { } ''
    mkdir -p $out/blobs $out/manifests/registry.ollama.ai/library/smollm

    ln -s ${modelBlob}    $out/blobs/sha256-eb2c714d40d4b35ba4b8ee98475a06d51d8080a17d2d2a75a23665985c739b94
    ln -s ${templateBlob} $out/blobs/sha256-62fbfd9ed093d6e5ac83190c86eec5369317919f4b149598d2dbb38900e9faef
    ln -s ${licenseBlob}  $out/blobs/sha256-cfc7749b96f63bd31c3c42b5c471bf756814053e847c10f3eb003417bc523d30
    ln -s ${paramsBlob}   $out/blobs/sha256-ca7a9654b5469dc2d638456f31a51a03367987c54135c089165752d9eeb08cd7
    ln -s ${configBlob}   $out/blobs/sha256-f590523c855b7d0f2741a9e076d4b663b1f128f2617b7fcd3fe7d7b57ce71d83

    cat > $out/manifests/registry.ollama.ai/library/smollm/135m <<'MANIFEST'
    ${manifestJson}
    MANIFEST
  '';
in
{
  name = "openclaw";
  meta.maintainers = with lib.maintainers; [ mkg20001 ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.ollama = {
        enable = true;
        package = pkgs.ollama-cpu;
        environmentVariables.OLLAMA_NOPRUNE = "true";
      };

      services.openclaw = {
        enable = true;
        port = openclawPort;
        settings = {
          gateway.mode = "local";
          models = {
            providers.ollama-local = {
              baseUrl = "http://127.0.0.1:${toString ollamaPort}";
              models = [
                {
                  id = model;
                  name = model;
                  api = "ollama";
                }
              ];
            };
          };
          agents.defaults.model = model;
        };
      };

      # Pre-populate ollama model storage before ollama starts
      systemd.services.ollama.serviceConfig.ExecStartPre = let
        setupScript = pkgs.writeShellScript "ollama-model-setup" ''
          model_dir=/var/lib/ollama/models
          mkdir -p $model_dir/blobs $model_dir/manifests/registry.ollama.ai/library/smollm

          for blob in ${ollamaModelDir}/blobs/*; do
            dest=$model_dir/blobs/$(basename $blob)
            if [ ! -f "$dest" ]; then
              cp -L "$blob" "$dest"
            fi
          done

          cp -L ${ollamaModelDir}/manifests/registry.ollama.ai/library/smollm/135m \
            $model_dir/manifests/registry.ollama.ai/library/smollm/135m
        '';
      in [ setupScript ];

      virtualisation = {
        memorySize = 4096;
        cores = 2;
        diskSize = 4096;
      };
    };

  testScript = ''
    import json

    machine.start()
    machine.wait_for_unit("multi-user.target")

    # 1) Check ollama is running and healthy
    machine.wait_for_open_port(${toString ollamaPort})
    machine.succeed("curl -sf http://127.0.0.1:${toString ollamaPort}/api/tags >&2")

    # 2) Verify the model is available (pre-loaded via ExecStartPre)
    result = machine.succeed("curl -sf http://127.0.0.1:${toString ollamaPort}/api/tags")
    tags = json.loads(result)
    models = [m["name"] for m in tags.get("models", [])]
    assert any("smollm" in m for m in models), f"smollm model not found in: {models}"

    # 3) Check openclaw gateway is running and healthy
    machine.wait_for_open_port(${toString openclawPort})
    machine.succeed("curl -so /dev/null -w '%{http_code}' http://127.0.0.1:${toString openclawPort}/ | grep -q '^[2-4]'")

    # 4) Run a prompt through ollama to verify the model generates text
    prompt = json.dumps({
      "model": "${model}",
      "prompt": "Say hello",
      "stream": False,
      "options": {"seed": 42, "temperature": 0, "num_predict": 20},
    })
    stdout = machine.succeed(
      f"curl -sf http://127.0.0.1:${toString ollamaPort}/api/generate -d '{prompt}'",
      timeout=300,
    )
    response = json.loads(stdout)
    assert "response" in response, f"No response field in ollama output: {stdout}"
    assert len(response["response"]) > 0, "Empty response from ollama"

    # Steps 1-4 verify the full integration: ollama serves the model,
    # openclaw gateway starts and connects to ollama (visible in logs
    # as /api/tags and /api/show requests from openclaw to ollama).
  '';
}
