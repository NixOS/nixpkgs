{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  podman,
  docker,
  go-md2man,
  withPodman ? true,
  withDocker ? false,

  # passthru
  ramalama,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ramalama";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "containers";
    repo = "ramalama";
    tag = "v${version}";
    hash = "sha256-1I0dVKtuQBSN2WKmL6P0ubVENqLTjqr+Y61pmFr+2Uk=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = [
    python3.pkgs.argcomplete
  ];

  buildInputs =
    lib.optionals withPodman [
      podman
    ]
    ++ lib.optionals withDocker [
      docker
    ];

  nativeBuildInputs = [
    go-md2man
  ];

  preBuild = ''
    make docs
  '';

  pythonImportsCheck = [
    "ramalama"
  ];

  nativeCheckInputs =
    [
      python3.pkgs.pytestCheckHook
    ]
    ++ lib.optionals withPodman [
      podman
    ]
    ++ lib.optionals withDocker [
      docker
    ];

  passthru = {
    tests = {
      withoutPodman = ramalama.override {
        withPodman = false;
      };
      withDocker = ramalama.override {
        withDocker = true;
      };
      withDockerOnly = ramalama.override {
        withPodman = false;
        withDocker = true;
      };
    };
  };

  # Otherwise test suite assumes podman machine is *running*
  preInstallCheck = lib.optional (stdenv.hostPlatform.isDarwin && withPodman) ''
    export RAMALAMA_CONTAINER_ENGINE=podman
  '';

  disabledTests = lib.optionals (!withPodman) [
    # Assumes podman is installed
    "test_load_config_defaults"
  ];

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
