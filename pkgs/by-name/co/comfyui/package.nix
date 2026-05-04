{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-update-script,
  python3,
}:

let
  pythonEnv = python3.withPackages (
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
    ]
  );
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "comfyui";
  version = "0.20.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CYrOLwfQvj4024WZ7OlGbJOxyj8qKHuwIfVluNVHIk4=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  postPatch = ''
        substituteInPlace comfy/cli_args.py \
          --replace-fail \
            'parser.add_argument("--base-directory", type=str, default=None, help="Set the ComfyUI base directory for models, custom_nodes, input, output, temp, and user directories.")' \
            'xdg_data_home = os.environ.get("XDG_DATA_HOME") or os.path.expanduser("~/.local/share")
    comfyui_data_home = os.path.join(xdg_data_home, "comfyui")
    parser.add_argument("--base-directory", type=str, default=comfyui_data_home, help="Set the ComfyUI base directory for models, custom_nodes, input, output, temp, and user directories.")' \
          --replace-fail \
            'database_default_path = os.path.abspath(
        os.path.join(os.path.dirname(__file__), "..", "user", "comfyui.db")
    )' \
            'database_default_path = os.path.join(comfyui_data_home, "user", "comfyui.db")'
  '';

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
