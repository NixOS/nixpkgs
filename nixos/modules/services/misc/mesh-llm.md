# MeshLLM {#module-services-mesh-llm}

[MeshLLM](https://github.com/Mesh-LLM/mesh-llm) pools the GPUs of several machines to serve large language models.
It offers them through an OpenAI-compatible API on port 9337 and a web console on port 3131.

## Serve a model {#module-services-mesh-llm-basic-usage}

Serve a model from MeshLLM's catalog:

```nix
{
  services.mesh-llm = {
    enable = true;
    settings.models = [ { model = "Qwen3-8B-Q4_K_M"; } ];
  };
}
```

MeshLLM downloads the model into `/var/lib/mesh-llm` on first start.
The console is then at <http://localhost:3131>.

## Use a GPU {#module-services-mesh-llm-gpus}

The package bundles a CPU runtime and, on Linux, a Vulkan runtime.
Vulkan works on most AMD, Intel and NVIDIA GPUs.

Add the CUDA runtime for this service:

```nix
{ pkgs, ... }:
{
  services.mesh-llm.package = pkgs.mesh-llm-cuda;
}
```

Use `pkgs.mesh-llm-rocm` for ROCm.
`pkgs.mesh-llm` also adds them when `cudaSupport` or `rocmSupport` is set in [](#opt-nixpkgs.config).
CUDA is unfree and needs `nixpkgs.config.allowUnfree`.
With the NVIDIA driver enabled ([](#opt-hardware.nvidia.enabled)), `nvidia-smi` is on the service's `PATH`, so MeshLLM can detect the GPUs.

## Join a mesh {#module-services-mesh-llm-joining}

Join a private mesh, reachable by its other nodes on a fixed port:

```nix
{
  services.mesh-llm = {
    enable = true;
    environmentFile = "/run/secrets/mesh-llm.env";
    meshPort = 7842;
    openFirewall = true;
  };
}
```

The environment file sets `MESH_LLM_JOIN_FILE` to the path of the invite token.
MeshLLM rereads the token whenever it rejoins.

Nodes talk to each other over QUIC.
{option}`services.mesh-llm.meshPort` fixes its UDP port, and {option}`services.mesh-llm.openFirewall` opens it for direct connections.
Without them, MeshLLM picks a random port and connects through NAT traversal and relays.

For other kinds of mesh, add a flag to {option}`services.mesh-llm.extraArgs`:

- `--auto` joins the public mesh.
  Other people's prompts then run on your machine, and yours on theirs.
- `--publish` publishes your own mesh for others to discover.
- `--mesh-discovery-mode mdns` keeps the mesh on the local network.
  MeshLLM then contacts no Nostr or public relays, and nodes still join with the invite token.
  mDNS needs UDP port 5353 open in {option}`networking.firewall.allowedUDPPorts`.

The API and console listen on localhost only.
To reach them from other machines, add `--listen-all` to {option}`services.mesh-llm.extraArgs`.
Then open TCP ports 9337 and 3131 in {option}`networking.firewall.allowedTCPPorts`.
On servers that don't need the console, add `--headless`.
The management API stays available.

## Add plugins {#module-services-mesh-llm-plugins}

Add plugins as `[[plugin]]` entries in {option}`services.mesh-llm.settings`, with `command` pointing at the plugin's executable.
Connect an existing OpenAI-compatible server with the `openai-endpoint` plugin:

```nix
{
  services.mesh-llm.settings.plugin = [
    {
      name = "openai-endpoint";
      command = "/path/to/openai-endpoint";
      url = "http://127.0.0.1:8000/v1";
    }
  ];
}
```

`mesh-llm plugins install` downloads prebuilt plugins instead.
They are built for other distributions and need [](#opt-programs.nix-ld.enable) on NixOS.
