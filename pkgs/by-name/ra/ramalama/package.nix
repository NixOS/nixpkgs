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

let
  # Upstream's MlxPlugin rejects hosts other than Apple-Silicon macOS:
  # https://github.com/containers/ramalama/blob/f9f4c93a565124b92a1a1e689c0fd865a1507499/ramalama/plugins/runtimes/inference/mlx.py#L85-L88
  mlxRuntimeSupported = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ramalama";
  version = "0.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "containers";
    repo = "ramalama";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k3VfZ9+ATu2Cwx531D0WVagjn1ZMIKR1i3yyq+3IGJ4=";
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

  postInstall = lib.optionalString withPodman ''
    wrapProgram $out/bin/ramalama \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            llama-cpp-vulkan
            podman
          ]
          ++ (with python3Packages; [
            huggingface-hub
          ])
          ++ lib.optionals mlxRuntimeSupported (
            with python3Packages;
            [
              mlx-lm
            ]
          )
        )
      }
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
        (stdenv.hostPlatform.isLinux && (stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isAarch64))
        {
          podman = callPackage ./tests/podman.nix {
            ramalama = finalAttrs.finalPackage;
          };
        }
    // lib.optionalAttrs mlxRuntimeSupported {
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
