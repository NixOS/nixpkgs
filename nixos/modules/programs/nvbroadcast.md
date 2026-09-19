# Nvbroadcast {#module-program-nvbroadcast}

_Source:_ {file}`modules/programs/nvbroadcast.nix`

_Upstream documentation:_ <https://github.com/Hkshoonya/nvidia-broadcast-linux>

NV Broadcast — Unofficial NVIDIA Broadcast for Linux and other OS.
AI-powered virtual camera with background removal, blur, replacement,
video enhancement, and noise cancellation. GPU accelerated. Open source.

To enable Nvbroadcast, add the following to your {file}`configuration.nix`:

```nix
{
  programs.nvbroadcast.enable = true;
}
```

If your system does not already configure the NVIDIA driver, enable the module's
basic NVIDIA defaults and choose whether to use the open kernel module:

```nix
{
  hardware.nvidia.open = true;

  programs.nvbroadcast = {
    enable = true;
    nvidia.enable = true;
  };
}
```

The {option}`programs.nvbroadcast.nvidia.enable` option defaults to `false`, so
existing NVIDIA configurations are left untouched.

CUDA and TensorRT modes use Nvbroadcast's GUI-managed optional runtime
installer. Runtime wheels are installed into a user-writable directory below XDG
data state, not into the immutable Nix store.
