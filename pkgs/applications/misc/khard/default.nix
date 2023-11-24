{ lib, python3, fetchPypi, khard, testers, installShellFiles }:

python3.pkgs.buildPythonApplication rec {
  version = "0.19.0";
  pname = "khard";
  format = "pyproject";
  disabled = python3.pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5ki+adfz7m0+FbxC9+IXHLn8oeLKLkASuU15lyDATKQ=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;
  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
    sphinxHook
    sphinx-autoapi
    sphinx-autodoc-typehints
    installShellFiles
  ];

  sphinxBuilders = [ "man" ];

  propagatedBuildInputs = with python3.pkgs; [
    atomicwrites
    configobj
    ruamel-yaml
    unidecode
    vobject
  ];

  postInstall = ''
    installShellCompletion --zsh misc/zsh/_khard
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
