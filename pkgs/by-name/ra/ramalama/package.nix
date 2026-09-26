{
  lib,
  stdenv,
  callPackage,
  python3Packages,
  fetchFromGitHub,
  go-md2man,

  llama-cpp-vulkan,
  podman,
  withPodman ? true,
  writableTmpDirAsHomeHook,

  # passthru
  ramalama,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ramalama";
  version = "0.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "containers";
    repo = "ramalama";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AwlB2JeOMFCXoIovqfr9nhy36QWC2m42kHFIGg4dJFo=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    argcomplete
    bcrypt
    pyyaml
    jinja2
  ];

  nativeBuildInputs = [
    go-md2man
  ];

  postPatch = ''
    substituteInPlace ramalama/config.py --replace-fail "{sys.prefix}" "$out"
    patchShebangs hack/markdown-preprocess
  '';

  preBuild = ''
    make docs
  '';

  postInstall =
    let
      binPackages = [
        llama-cpp-vulkan
        python3Packages.huggingface-hub
      ]
      ++ lib.optional stdenv.hostPlatform.isDarwin python3Packages.mlx-lm
      ++ lib.optional withPodman podman;
    in
    ''
      wrapProgram $out/bin/ramalama \
        --prefix PATH : ${lib.makeBinPath binPackages}
    '';

  pythonImportsCheck = [
    "ramalama"
  ];

  nativeCheckInputs = [
    podman
    python3Packages.pytestCheckHook
    python3Packages.requests
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  passthru = {
    updateScript = ./update.sh;

    tests = {
      nocontainer = callPackage ./tests/nocontainer.nix {
        ramalama = finalAttrs.finalPackage;
      };

      withoutPodman = ramalama.override {
        withPodman = false;
      };
    }
    //
      lib.optionalAttrs
        (
          stdenv.hostPlatform.isDarwin
          || (stdenv.hostPlatform.isLinux && (stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isAarch64))
        )
        {
          podman = callPackage ./tests/podman.nix { };
        }
    // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
      mlx = callPackage ./tests/mlx.nix {
        ramalama = finalAttrs.finalPackage;
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
})
