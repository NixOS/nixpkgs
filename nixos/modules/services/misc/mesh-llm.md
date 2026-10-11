# MeshLLM {#module-services-mesh-llm}

[MeshLLM](https://github.com/Mesh-LLM/mesh-llm) pools the GPUs of several
machines to serve large language models, and offers them through an
OpenAI-compatible API (port 9337) and a web console (port 3131).

## Basic usage {#module-services-mesh-llm-basic-usage}

A node that serves one model from MeshLLM's catalog:

```nix
{
  services.mesh-llm = {
    enable = true;
    settings.models = [ { model = "Qwen3-8B-Q4_K_M"; } ];
  };
}
```

MeshLLM downloads the model into `/var/lib/mesh-llm` on first start. The
console is then at <http://localhost:3131>.

## GPUs {#module-services-mesh-llm-gpus}

The package bundles a CPU runtime and, on Linux, a Vulkan runtime, which works
on most AMD, Intel and NVIDIA GPUs. CUDA and ROCm runtimes follow the
nixpkgs-wide [](#opt-nixpkgs.config) settings `cudaSupport` and `rocmSupport`;
to set them for this service alone:

```nix
{ pkgs, ... }:
{
  services.mesh-llm.package = pkgs.mesh-llm.override { cudaSupport = true; };
}
```

CUDA is unfree and needs `nixpkgs.config.allowUnfree`. With the NVIDIA driver
enabled ([](#opt-hardware.nvidia.enabled)), `nvidia-smi` is on the node's
`PATH` so MeshLLM can detect the GPUs.

## Joining a mesh {#module-services-mesh-llm-joining}

A node in a private mesh, reachable by its peers on a fixed port:

```nix
{
  services.mesh-llm = {
    enable = true;
    # Contains MESH_LLM_JOIN_FILE=/path/to/invite-token
    environmentFile = "/run/secrets/mesh-llm.env";
    meshPort = 7842;
    openFirewall = true;
  };
}
```

MeshLLM rereads the invite token whenever it rejoins. Other kinds of mesh:

- The public mesh: add `--auto` to {option}`services.mesh-llm.extraArgs`.
  Prompts then run on other people's machines, and yours on theirs.
- To publish your own mesh for others to discover, add `--publish`.
- A mesh that stays on the local network: add `--mesh-discovery-mode mdns`.
  MeshLLM then contacts no Nostr or public relays; nodes still join with the
  invite token. mDNS needs UDP port 5353 open
  ({option}`networking.firewall.allowedUDPPorts`).

Nodes talk to each other over QUIC. {option}`services.mesh-llm.meshPort` fixes
its UDP port and {option}`services.mesh-llm.openFirewall` opens it for direct
connections; without them, MeshLLM picks a random port and connects through NAT
traversal and relays.

The API and console listen on localhost only. Add `--listen-all` to
{option}`services.mesh-llm.extraArgs` to reach them from other machines;
`openFirewall` then opens their ports too. Servers that don't need the web
console can add `--headless`, as upstream's container image does; the
management API stays available.

## Plugins {#module-services-mesh-llm-plugins}

Configure plugins, such as `openai-endpoint` for an existing
OpenAI-compatible server, in `[[plugin]]` entries, with `command` pointing at
the plugin's executable:

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

`mesh-llm plugins install` downloads prebuilt plugins instead. They are built
for other distributions and need [](#opt-programs.nix-ld.enable) on NixOS.
