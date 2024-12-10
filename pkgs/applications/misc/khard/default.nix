{
  lib,
  python3,
  fetchPypi,
  khard,
  testers,
}:

python3.pkgs.buildPythonApplication rec {
  version = "0.19.1";
  pname = "khard";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-WfMKDaPD2j6wT02+GO5HY5E7aF2Z7IQY/VdKiMSRxJA=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
    sphinxHook
    sphinx-autoapi
    sphinx-autodoc-typehints
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
