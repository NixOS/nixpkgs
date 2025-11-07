{
  lib,
  python3,
  fetchPypi,
  khard,
  testers,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "khard";
  version = "0.20.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F48yzPAcBQtc2ec2KCWD3ppkRf2Y4AOI33kiB2KbvdA=";
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
    # see https://github.com/scheibler/khard/issues/263
    export COLUMNS=80
  '';

  pythonImportsCheck = [ "khard" ];

  passthru.tests.version = testers.testVersion { package = khard; };

  meta = {
    homepage = "https://github.com/scheibler/khard";
    description = "Console carddav client";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "khard";
  };
}
