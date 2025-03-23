{
  lib,
  fetchFromSourcehut,
  buildPythonPackage,
  srht,
  pyyaml,
  buildsrht,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "scmsrht";
  version = "0.22.24";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "scm.sr.ht";
    rev = version;
    hash = "sha256-9IgMmYzInfrten7z8bznlSFJlUjHf3k3z76lkP6tP50=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    srht
    pyyaml
    buildsrht
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  dontUseSetuptoolsCheck = true;

  pythonImportsCheck = [ "scmsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/scm.sr.ht";
    description = "Shared support code for sr.ht source control services";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      eadwu
      christoph-heiss
    ];
  };
}
