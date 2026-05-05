{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-update-script,
  python3Packages,
}:

let
  appDependencies =
    ps: with ps; [
      aiohttp
      alembic
      av
      blake3
      comfy-aimdo
      comfy-kitchen
      comfyui-embedded-docs
      comfyui-frontend-package
      comfyui-manager
      comfyui-workflow-templates
      einops
      filelock
      glfw
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
    ];
  pythonEnv = python3Packages.python.withPackages appDependencies;
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "comfyui";
  version = "0.20.1";

  pyproject = false;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CYrOLwfQvj4024WZ7OlGbJOxyj8qKHuwIfVluNVHIk4=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  patches = [ ./use-writable-runtime-paths.patch ];

  dependencies = appDependencies python3Packages;

  dontBuild = true;
  dontWrapPythonPrograms = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/comfyui $out/bin
    cp -r . $out/share/comfyui

    makeBinaryWrapper ${lib.getExe pythonEnv} $out/bin/comfyui \
      --add-flag "$out/share/comfyui/main.py"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    "$out"/bin/comfyui --help
    export XDG_DATA_HOME="$(mktemp -d)"
    "$out"/bin/comfyui --cpu --quick-test-for-ci

    runHook postInstallCheck
  '';

  passthru = {
    inherit pythonEnv;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Modular diffusion model GUI, API, and backend with graph and nodes interface";
    homepage = "https://github.com/Comfy-Org/ComfyUI";
    changelog = "https://github.com/Comfy-Org/ComfyUI/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "comfyui";
    maintainers = with lib.maintainers; [
      caniko
      jk
    ];
    platforms = lib.platforms.linux;
  };
})
