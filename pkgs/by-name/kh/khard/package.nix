{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  versionCheckHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "khard";
  version = "0.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lucc";
    repo = "khard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fBfnKxluEYzlqwoXZ+hClLtayfjTzATkqc/1JN7nwIo=";
  };

  build-system = with python3.pkgs; [
    setuptools
    setuptools-scm
    sphinxHook
    sphinx-argparse
    sphinx-autoapi
    sphinx-autodoc-typehints
  ];

  sphinxBuilders = [ "man" ];

  dependencies = with python3.pkgs; [
    configobj
    ruamel-yaml
    unidecode
    vobject
  ];

  postInstall = ''
    install -D misc/zsh/_khard $out/share/zsh/site-functions/_khard
  '';

  preCheck = ''
    # see https://github.com/lucc/khard/issues/263
    export COLUMNS=80
  '';

  pythonImportsCheck = [ "khard" ];

  nativeCheckInputs = [
    versionCheckHook
    python3.pkgs.pytestCheckHook
  ];

  pytestFlags = [
    # Nixpkgs' default is `--capture=fd`, and with it, 2 command mock tests
    # fail, see: https://github.com/lucc/khard/issues/353
    "--capture=no"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # https://github.com/lucc/khard/issues/354
    "test/test_khard.py::TestSortContacts::test_sorting_of_korean_names"
  ];

  meta = {
    homepage = "https://github.com/lucc/khard";
    description = "Console carddav client";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      doronbehar
    ];
    mainProgram = "khard";
  };
})
