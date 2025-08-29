{
  lib,
  python3,
  fetchFromGitHub,
  go-md2man,

  podman,
  withPodman ? true,

  # passthru
  ramalama,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ramalama";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "containers";
    repo = "ramalama";
    tag = "v${version}";
    hash = "sha256-Hozyf0yfB0XhxWeA3SS24BPfDDXYa2AXY8/gLh8ZFcU=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = [
    python3.pkgs.argcomplete
  ];

  nativeBuildInputs = [
    go-md2man
  ];

  preBuild = ''
    make docs
  '';

  postInstall = lib.optionalString withPodman ''
    wrapProgram $out/bin/ramalama \
      --prefix PATH : ${lib.makeBinPath [ podman ]}
  '';

  pythonImportsCheck = [
    "ramalama"
  ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
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
