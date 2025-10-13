{
  lib,
  python3Packages,
  fetchFromGitHub,
  makeWrapper,

  additionalDependencies ? [],

  callPackage,
}:

python3Packages.buildPythonApplication rec {
  pname = "comfyui";
  version = "0.3.64";
  # wrapping the source since it's designed to be ran by hand
  # as `python ./main.py`
  format = "other";

  src = fetchFromGitHub {
    owner = "comfyanonymous";
    repo = "ComfyUI";
    rev = "v${version}";
    hash = "sha256-p0u2rZZ3AHn8InGWzu5sTTnYuYSINnDFnzuPgjqSLGw=";
  };

  patches = [
    # makes usage of `comfyui` cli with altered base-dir mostly painless
    # https://github.com/comfyanonymous/ComfyUI/pull/9803
    ./make-custom_nodes-if-not-exists.patch
  ];

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  dependencies = with python3Packages; [
    aiohttp
    alembic
    av
    comfyui-embedded-docs
    comfyui-frontend-package
    comfyui-workflow-templates
    einops
    kornia
    numpy
    pillow
    psutil
    pydantic
    pydantic-settings
    pyyaml
    safetensors
    scipy
    sentencepiece
    soundfile
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
  ] ++ additionalDependencies;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,opt/comfyui}
    # Copy the app files
    cp -r ./ $out/opt/comfyui/

    runHook postInstall
  '';

  # create our executable `comfyui`
  # since the nix store is read-only we provide a sensible default alternative
  # for --base-dir and --database-url, putting contents within $XDG_DATA_HOME/comfyui
  # if the same flags are defined later those values will take precedence
  #
  # users will still need to specify different launch options if
  # "Torch not compiled with CUDA enabled"
  # --cpu should always work but would be undesirable as a default
  postFixup = ''
    makeWrapper ${python3Packages.python.interpreter} $out/bin/comfyui \
      --add-flags "$out/opt/comfyui/main.py" \
      --add-flags '--base-dir "''${XDG_DATA_HOME:-$HOME/.local/share}/comfyui"' \
      --add-flags '--database-url "sqlite:////''${XDG_DATA_HOME:-$HOME/.local/share}/comfyui/user/comfyui.db"' \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    "$out"/bin/comfyui --help

    runHook postInstallCheck
  '';

  # python3Packages.
  passthru.plugins.comfyui-gguf = callPackage ./nodes/comfyui-gguf.nix {
    mkComfyuiNode = passthru.mkComfyuiNode;
    # pythonPackages = python3Packages;
  };
  passthru.mkComfyuiNode = callPackage ./node-builder.nix { pythonPackages = python3Packages; };

  meta = {
    description = "The most powerful and modular diffusion model GUI, api and backend with a graph/nodes interface";
    homepage = "https://github.com/comfyanonymous/ComfyUI";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      jk
    ];
    mainProgram = "comfyui";
  };
}
