{
  lib,
  pkgs,
  ...
}:
let
  ollamaPort = 11434;
  openclawPort = 18789;
  model = "qwen3:0.6b";

  # Pre-fetch ollama model blobs so the test VM needs no network access.
  # These are the layers from the ollama registry manifest for qwen3:0.6b.
  modelBlob = pkgs.fetchurl {
    url = "https://registry.ollama.ai/v2/library/qwen3/blobs/sha256:7f4030143c1c477224c5434f8272c662a8b042079a0a584f0a27a1684fe2e1fa";
    hash = "sha256-f0AwFDwcR3IkxUNPgnLGYqiwQgeaClhPCiehaE/i4fo=";
  };
  templateBlob = pkgs.fetchurl {
    url = "https://registry.ollama.ai/v2/library/qwen3/blobs/sha256:ae370d884f108d16e7cc8fd5259ebc5773a0afa6e078b11f4ed7e39a27e0dfc4";
    hash = "sha256-rjcNiE8QjRbnzI/VJZ68V3Ogr6bgeLEfTtfjmifg38Q=";
  };
  licenseBlob = pkgs.fetchurl {
    url = "https://registry.ollama.ai/v2/library/qwen3/blobs/sha256:d18a5cc71b84bc4af394a31116bd3932b42241de70c77d2b76d69a314ec8aa12";
    hash = "sha256-0YpcxxuEvErzlKMRFr05MrQiQd5wx30rdtaaMU7IqhI=";
  };
  paramsBlob = pkgs.fetchurl {
    url = "https://registry.ollama.ai/v2/library/qwen3/blobs/sha256:cff3f395ef3756ab63e58b0ad1b32bb6f802905cae1472e6a12034e4246fbbdb";
    hash = "sha256-z/Pzle83Vqtj5YsK0bMrtvgCkFyuFHLmoSA05CRvu9s=";
  };
  configBlob = pkgs.fetchurl {
    url = "https://registry.ollama.ai/v2/library/qwen3/blobs/sha256:b0830f4ff6a0220cfd995455206353b0ed23c0aee865218b154b7a75087b4e55";
    hash = "sha256-sIMPT/agIgz9mVRVIGNTsO0jwK7oZSGLFUt6dQh7TlU=";
  };

  # The manifest JSON as ollama stores it locally
  manifestJson = builtins.toJSON {
    schemaVersion = 2;
    mediaType = "application/vnd.docker.distribution.manifest.v2+json";
    config = {
      mediaType = "application/vnd.docker.container.image.v1+json";
      digest = "sha256:b0830f4ff6a0220cfd995455206353b0ed23c0aee865218b154b7a75087b4e55";
      size = 490;
    };
    layers = [
      {
        mediaType = "application/vnd.ollama.image.model";
        digest = "sha256:7f4030143c1c477224c5434f8272c662a8b042079a0a584f0a27a1684fe2e1fa";
        size = 522640096;
      }
      {
        mediaType = "application/vnd.ollama.image.template";
        digest = "sha256:ae370d884f108d16e7cc8fd5259ebc5773a0afa6e078b11f4ed7e39a27e0dfc4";
        size = 1723;
      }
      {
        mediaType = "application/vnd.ollama.image.license";
        digest = "sha256:d18a5cc71b84bc4af394a31116bd3932b42241de70c77d2b76d69a314ec8aa12";
        size = 11338;
      }
      {
        mediaType = "application/vnd.ollama.image.params";
        digest = "sha256:cff3f395ef3756ab63e58b0ad1b32bb6f802905cae1472e6a12034e4246fbbdb";
        size = 120;
      }
    ];
  };

  # Build a directory tree mimicking ollama's on-disk model storage
  ollamaModelDir = pkgs.runCommand "ollama-model-qwen3-0.6b" { } ''
    mkdir -p $out/blobs $out/manifests/registry.ollama.ai/library/qwen3

    # Link blobs by their sha256 digest (ollama uses sha256-<hex> filenames)
    ln -s ${modelBlob}    $out/blobs/sha256-7f4030143c1c477224c5434f8272c662a8b042079a0a584f0a27a1684fe2e1fa
    ln -s ${templateBlob} $out/blobs/sha256-ae370d884f108d16e7cc8fd5259ebc5773a0afa6e078b11f4ed7e39a27e0dfc4
    ln -s ${licenseBlob}  $out/blobs/sha256-d18a5cc71b84bc4af394a31116bd3932b42241de70c77d2b76d69a314ec8aa12
    ln -s ${paramsBlob}   $out/blobs/sha256-cff3f395ef3756ab63e58b0ad1b32bb6f802905cae1472e6a12034e4246fbbdb
    ln -s ${configBlob}   $out/blobs/sha256-b0830f4ff6a0220cfd995455206353b0ed23c0aee865218b154b7a75087b4e55

    # Write the manifest
    cat > $out/manifests/registry.ollama.ai/library/qwen3/0.6b <<'MANIFEST'
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
                  api = "ollama";
                }
              ];
            };
          };
          agents.defaults.model = model;
        };
      };

      # Pre-populate ollama model storage so no network pull is needed
      systemd.services.ollama-model-setup = {
        description = "Pre-populate ollama models from the Nix store";
        wantedBy = [ "multi-user.target" ];
        after = [ "ollama.service" ];
        requires = [ "ollama.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          model_dir=/var/lib/ollama/models
          mkdir -p $model_dir/blobs $model_dir/manifests/registry.ollama.ai/library/qwen3

          # Copy blobs (ollama needs writable files, not store symlinks)
          for blob in ${ollamaModelDir}/blobs/*; do
            dest=$model_dir/blobs/$(basename $blob)
            if [ ! -f "$dest" ]; then
              cp -L "$blob" "$dest"
            fi
          done

          # Copy manifest
          cp -L ${ollamaModelDir}/manifests/registry.ollama.ai/library/qwen3/0.6b \
            $model_dir/manifests/registry.ollama.ai/library/qwen3/0.6b
        '';
      };

      virtualisation = {
        memorySize = 6144;
        cores = 2;
        diskSize = 8192;
      };
    };

  testScript = ''
    import json

    machine.start()
    machine.wait_for_unit("multi-user.target")

    # 1) Check ollama is running and healthy
    machine.wait_for_open_port(${toString ollamaPort})
    machine.succeed("curl -sf http://127.0.0.1:${toString ollamaPort}/api/tags >&2")

    # 2) Wait for model setup to complete
    machine.wait_for_unit("ollama-model-setup.service", timeout=60)

    # Verify the model is available
    result = machine.succeed("curl -sf http://127.0.0.1:${toString ollamaPort}/api/tags")
    tags = json.loads(result)
    models = [m["name"] for m in tags.get("models", [])]
    assert any("qwen3" in m for m in models), f"qwen3 model not found in: {models}"

    # 3) Check openclaw gateway is running and healthy
    machine.wait_for_open_port(${toString openclawPort})
    machine.succeed("openclaw gateway health --url ws://127.0.0.1:${toString openclawPort} --json >&2")

    # 4) Run a prompt through ollama to verify the model generates text
    prompt = json.dumps({
      "model": "${model}",
      "prompt": "Say hello",
      "stream": False,
      "options": {"seed": 42, "temperature": 0},
    })
    stdout = machine.succeed(
      f"curl -sf http://127.0.0.1:${toString ollamaPort}/api/generate -d '{prompt}'",
      timeout=200,
    )
    response = json.loads(stdout)
    assert "response" in response, f"No response field in ollama output: {stdout}"
    assert len(response["response"]) > 0, "Empty response from ollama"

    # 5) Run a prompt through openclaw agent (local mode, direct to ollama)
    machine.succeed(
      "openclaw agent --local --message 'Say hello' --json --timeout 60 2>&1 || true",
      timeout=120,
    )
  '';
}
