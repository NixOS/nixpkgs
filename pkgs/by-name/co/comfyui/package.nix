{
  lib,
  callPackage,
  cudaPackages_13,
  fetchFromGitHub,
  makeBinaryWrapper,
  python3,
  stdenvNoCC,
  withManager ? false,
}:

let
  # Using overrideScope does not work when using `withPackages appDependencies`
  # and creates a an env without those overrides
  python = python3.override {
    self = python;
    packageOverrides = final: prev: {
      # older cudaPackages are not supported and actively disabled
      # https://github.com/Comfy-Org/ComfyUI/blob/v0.27.0/comfy/quant_ops.py#L25
      torch = prev.torch.override {
        cudaPackages = cudaPackages_13;
      };
      triton = prev.triton.override {
        cudaPackages = cudaPackages_13;
      };
    };
  };

  appDependencies =
    ps:
    with ps;
    [
      aiohttp
      alembic
      av
      blake3
      comfy-aimdo
      comfy-angle
      comfy-kitchen
      comfyui-embedded-docs
      comfyui-frontend-package
      comfyui-workflow-templates
      einops
      filelock
      kornia
      numpy
      pillow
      psutil
      pydantic
      pydantic-settings
      pyopengl
      pyyaml
      requests
      safetensors
      scipy
      sentencepiece
      simpleeval
      spandrel
      sqlalchemy
      tokenizers
      torch
      torchaudio
      torchsde
      torchvision
      tqdm
      transformers
      yarl
    ]
    ++ lib.optionals withManager [
      ps.comfyui-manager
    ];

  pythonEnv = python.withPackages appDependencies;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "comfyui";
  version = "0.33.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r6amApYXBjfE8+UvhiJ/7VcUibd4kd5i+JLPXxo8H9w=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  patches = [ ./use-writable-runtime-paths.patch ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/comfyui $out/bin
    cp -r . $out/share/comfyui

    makeBinaryWrapper ${lib.getExe pythonEnv} $out/bin/comfyui \
      --add-flag "$out/share/comfyui/main.py" \
      --unset NIX_PYTHONPATH \
      --unset PYTHONPATH

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    PYTHONPATH=${pythonEnv}/${python.sitePackages} ${lib.getExe python.pkgs.pip} install --break-system-packages --dry-run --no-index -r requirements.txt
    "$out"/bin/comfyui --help
    export XDG_DATA_HOME="$(mktemp -d)"
    "$out"/bin/comfyui --cpu --quick-test-for-ci

    runHook postInstallCheck
  '';

  passthru = {
    inherit python pythonEnv;
  }
  // lib.optionalAttrs (!withManager) {
    tests.withManager = callPackage ./package.nix {
      withManager = true;
    };
  };

  meta = {
    description = "Modular diffusion model GUI, API, and backend with graph and nodes interface";
    homepage = "https://github.com/Comfy-Org/ComfyUI";
    changelog = "https://github.com/Comfy-Org/ComfyUI/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "comfyui";
    maintainers = with lib.maintainers; [
      caniko
      SuperSandro2000
    ];
    platforms = lib.platforms.linux;
  };
})
