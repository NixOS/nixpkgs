# ComfyUI {#module-services-comfyui}

[ComfyUI](https://github.com/Comfy-Org/ComfyUI) is a modular diffusion model GUI, API, and backend with a graph/nodes interface.

A minimal configuration is:

```nix
{
  services.comfyui.enable = true;
}
```

Models and additional Python packages can be managed declaratively:

- {option}`services.comfyui.models` fetches model files at build time and
  symlinks them into `/var/lib/comfyui/models/<installPath>/<name>`.

  ```nix
  {
    services.comfyui.models = [
      {
        name = "RealESRGAN_x4plus_anime_6B.pth";
        url = "https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth";
        hash = "sha256-+HLYN9PJDtLgUie+1xGvVnGm/RyffX6RyRGmHxVemdo=";
        installPaths = [ "upscale_models" ];
      }
    ];
  }
  ```

- {option}`services.comfyui.extraPackages` adds extra Python packages to
  ComfyUI's environment, typically for custom node dependencies.

  ```nix
  {
    services.comfyui.extraPackages = python3Packages: with python3Packages; [ flask ];
  }
  ```

- {option}`services.comfyui.acceleration` selects the hardware acceleration
  device (`"cpu"` / `"cuda"`, defaulting to following `nixpkgs.config.cudaSupport`).
