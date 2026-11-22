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

Enable a GPU backend with the nixpkgs settings, for example CUDA:

```nix
{
  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
  };
}
```

`cudaCapabilities` limits the GPUs the CUDA runtime is built for, see [Configuring Nixpkgs for CUDA](https://nixos.org/manual/nixpkgs/unstable/#cuda-configuring-nixpkgs-for-cuda).
By default `pkgs.mesh-llm` bundles the CPU runtime on Linux.
Setting `rocmSupport` in [](#opt-nixpkgs.config) enables ROCm instead.
CUDA is unfree and needs `nixpkgs.config.allowUnfree`.
Vulkan (most AMD, Intel and NVIDIA GPUs) has no nixpkgs setting; enable it on the runtime mesh-llm bundles:

```nix
{ pkgs, ... }:
{
  services.mesh-llm.package = pkgs.mesh-llm.override {
    skippy-native-runtime = pkgs.skippy-native-runtime.override { vulkanSupport = true; };
  };
}
```

To build ROCm only for your AMD GPUs, set `rocmGpuTargets` the same way.
The service uses only the bundled runtime.
Set [](#opt-services.mesh-llm.allowRuntimeDownloads) to let MeshLLM download a prebuilt runtime when the bundled one does not fit the host.
When the NVIDIA driver is in use, for example with `services.xserver.videoDrivers = [ "nvidia" ];` (see [](#opt-hardware.nvidia.enabled)), `nvidia-smi` is on the service's `PATH`, so MeshLLM can detect the GPUs.

CUDA 13 needs NVIDIA driver 580 or newer.
With an older driver, such as JetPack 6 on Jetson boards, MeshLLM skips the CUDA runtime.
Switch the CUDA package set to CUDA 12 in an overlay, so every CUDA package on the system uses the same version:

```nix
{
  nixpkgs.overlays = [ (final: prev: { cudaPackages = final.cudaPackages_12; }) ];
}
```

## Join a mesh {#module-services-mesh-llm-joining}

Join a private mesh, reachable by its other nodes on a fixed port:

```nix
{
  services.mesh-llm = {
    enable = true;
    joinTokenFile = "/run/secrets/mesh-llm-invite-token";
    meshPort = 7842;
    openFirewall = true;
  };
}
```

[](#opt-services.mesh-llm.joinTokenFile) is read as a systemd credential, so the file can stay readable only by root.
systemd copies it when the service starts: to change the token, replace the file and restart `mesh-llm.service`.

Nodes talk to each other over QUIC.
[](#opt-services.mesh-llm.meshPort) fixes its UDP port, and [](#opt-services.mesh-llm.openFirewall) opens it for direct connections.
Without them, MeshLLM picks a random port and connects through NAT traversal and relays.

For other kinds of mesh, add a flag to [](#opt-services.mesh-llm.extraArgs):

- `--auto` joins the public mesh.
  Other people's prompts then run on your machine, and yours on theirs.
- `--publish` publishes your own mesh for others to discover.
- `--mesh-discovery-mode mdns` keeps the mesh on the local network.
  MeshLLM then contacts no Nostr or public relays, and nodes still join with the invite token.
  mDNS needs UDP port 5353 open in [](#opt-networking.firewall.allowedUDPPorts).

The API and console listen on localhost only.
To reach them from other machines, add `--listen-all` to [](#opt-services.mesh-llm.extraArgs).
Then open TCP ports 9337 and 3131 in [](#opt-networking.firewall.allowedTCPPorts).
On servers that don't need the console, add `--headless`.
The management API stays available.

## Own the node {#module-services-mesh-llm-owner}

An owner identity attests that a node belongs to you.
Meshes can then admit only owned nodes, and the console can save configuration.
Create a keystore and give it to the service:

```ShellSession
$ mesh-llm auth init --no-passphrase --owner-key ./owner-keystore.json
```

Without `--no-passphrase`, `auth init` locks a new keystore with a secret in the desktop's keychain when one is available, and the service can't read that.
Keep the file in a secret manager instead, such as sops-nix or agenix.

```nix
{
  services.mesh-llm = {
    ownerKeyFile = "/run/secrets/mesh-llm-owner-keystore.json";
    extraArgs = [
      "--trust-policy"
      "allowlist"
      "--trust-owner"
      "<owner-id>"
    ];
  };
}
```

`mesh-llm auth status` shows the owner ID.
The service doesn't start if it can't load the keystore.
For an encrypted keystore, set `MESH_LLM_OWNER_PASSPHRASE` in one of the [](#opt-services.mesh-llm.environmentFiles).
When [](#opt-services.mesh-llm.settings) is set, the service rewrites the configuration at every start, and changes saved in the console last only until then.

## Add plugins {#module-services-mesh-llm-plugins}

Add plugins as `[[plugin]]` entries in [](#opt-services.mesh-llm.settings), with `command` pointing at the plugin's executable.
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
