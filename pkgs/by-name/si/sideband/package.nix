{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "sideband";
  version = "1.9.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "Sideband";
    tag = finalAttrs.version;
    hash = "sha256-Dbhi4Sz+a42OILXcSfNNM4UDqMV5gHJ5xfYUMEON3ws=";
  };

  # Unable to upstream all of this
  # Reason: An owner of this repository has disabled the ability to open pull requests.
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail \
        "lxst>=0.4.6" \
        "lxst" \
      --replace-fail \
        '"kivymd")' \
        '"sbapp/kivymd")'

    substituteInPlace sbapp/main.py \
      --replace-fail \
        "1.9.2" \
        "1.9.6"
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies =
    with python3Packages;
    [
      audioop-lts
      beautifulsoup4
      ffpyplayer
      kivy
      lxmf
      lxst
      materialyoucolor
      mistune
      numpy
      pillow
      pyaudio
      pycodec2
      qrcode
      rns
      sh
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
    changelog = "https://github.com/markqvist/Sideband/releases/tag/${finalAttrs.version}";
    description = "LXMF client allowing you to communicate with people or LXMF-compatible systems over Reticulum networks";
    homepage = "https://github.com/markqvist/Sideband";
    license = lib.licenses.cc-by-nc-sa-40;
    maintainers = with lib.maintainers; [
      drupol
    ];
    mainProgram = "sideband";
  };
})
