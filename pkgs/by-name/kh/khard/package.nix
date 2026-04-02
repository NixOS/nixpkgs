{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  versionCheckHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "khard";
  version = "0.20.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lucc";
    repo = "khard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5ZKLOwoAzY36htMzMLpdwn1Xo34rGe56+TFuHRfFB9Q=";
  };

  build-system = with python3.pkgs; [
    setuptools
    setuptools-scm
  ];

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

  pytestFlagsArray = [
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
