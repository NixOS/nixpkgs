{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "containers";
    repo = "ramalama";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AqX8pNbeDPCxlwaSJg4+XVrfypvXGR77q8tkI7t3vTY=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    argcomplete
    bcrypt
    pyyaml
    jsonschema
    jinja2
  ];

  nativeBuildInputs = [
    go-md2man
  ];

  patches = [
    # fix darwin tests: https://github.com/containers/ramalama/pull/2567
    (fetchpatch {
      url = "https://github.com/containers/ramalama/commit/2b51b749b706261a5f704b4d785dbd45447b14b6.patch";
      hash = "sha256-HV7gn0W7b0P7OS53Js5JdHoFjvE7tO4e3RMReGZpRIo=";
    })
  ];

  postPatch = ''
    substituteInPlace ramalama/config.py --replace-fail "{sys.prefix}" "$out"
  '';

  preBuild = ''
    make docs
  '';

  postInstall =
    let
      binPackages = [
        llama-cpp-vulkan
      ]
      ++ (with python3Packages; [
        huggingface-hub
        mlx-lm
      ])
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
})
