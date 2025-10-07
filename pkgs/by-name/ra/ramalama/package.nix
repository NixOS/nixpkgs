{
  lib,
  python3,
  fetchFromGitHub,
  go-md2man,

  # TODO: switch to llama-cpp-vulkan when moltenvk is upgraded to 1.3.0:
  # https://github.com/NixOS/nixpkgs/pull/434130
  llama-cpp,
  podman,
  withPodman ? true,

  # passthru
  ramalama,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ramalama";
  version = "0.12.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "containers";
    repo = "ramalama";
    tag = "v${version}";
    hash = "sha256-PnuAPQ9RF7IRnmHtUrwDRXIKEzZBDEU2mWfG5FyfY0c=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    argcomplete
    pyyaml
  ];

  nativeBuildInputs = [
    go-md2man
  ];

  preBuild = ''
    make docs
  '';

  postInstall = lib.optionalString withPodman ''
    wrapProgram $out/bin/ramalama \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            llama-cpp
            podman
          ]
          ++ (
            with python3.pkgs;
            [
              huggingface-hub
            ]
            ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform mlx-lm) mlx-lm
          )
        )
      }
  '';

  pythonImportsCheck = [
    "ramalama"
  ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
  ];

  # Enable when https://github.com/containers/ramalama/pull/1891 is released
  disabledTests = [
    "test_ollama_model_pull"
  ];

  passthru = {
    tests = {
      withoutPodman = ramalama.override {
        withPodman = false;
      };
    };
  };

  meta = {
    description = "Serving AI models locally using familiar container workflows";
    longDescription = ''
      Ramalama is an open-source developer tool that simplifies the local
      serving of AI models from any source and facilitates their use for
      inference in production, all through the familiar language of containers
    '';
    homepage = "https://ramalama.ai/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ booxter ];
    mainProgram = "ramalama";
  };
}
