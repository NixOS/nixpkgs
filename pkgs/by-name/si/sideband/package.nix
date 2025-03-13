{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "sideband";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "Sideband";
    tag = version;
    hash = "sha256-tTduoP6Gh/8uy1a/qp8ohGpdDmsS61sNyaAQjdvvvb8=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  pythonRelaxDeps = [
    "numpy"
  ];

  dependencies =
    with python3Packages;
    [
      rns
      lxmf
      kivy
      pillow
      qrcode
      materialyoucolor
      ffpyplayer
      sh
      numpy
      mistune
      beautifulsoup4
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      pycodec2
      pyaudio
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      pyobjus
    ];

  pythonImportsCheck = [ "sbapp" ];

  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "LXMF client allowing you to communicate with people or LXMF-compatible systems over Reticulum networks";
    homepage = "https://github.com/markqvist/Sideband";
    changelog = "https://github.com/markqvist/Sideband/releases/tag/${version}";
    license = lib.licenses.cc-by-nc-sa-40;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "sideband";
  };
}
