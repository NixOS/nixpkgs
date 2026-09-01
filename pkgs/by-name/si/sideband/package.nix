{
  lib,
  python313Packages, # Require a working version of Kivy, which is not yet working with Python 3.14
  fetchFromGitHub,
  versionCheckHook,
}:

python313Packages.buildPythonApplication (finalAttrs: {
  pname = "sideband";
  version = "2.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "Sideband";
    tag = finalAttrs.version;
    hash = "sha256-RCSSyTtt2eN9hYT1xzPYjJloPjnkIS6bo21PHrlg5S8=";
  };

  # Unable to upstream all of this
  # Reason: An owner of this repository has disabled the ability to open pull requests.
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail \
        '"kivymd")' \
        '"sbapp/kivymd")'

    substituteInPlace sbapp/main.py \
      --replace-fail \
        "1.9.2" \
        ${finalAttrs.version}
  '';

  build-system = with python313Packages; [
    setuptools
  ];

  dependencies =
    with python313Packages;
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
      pyaudio
      pycodec2
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
