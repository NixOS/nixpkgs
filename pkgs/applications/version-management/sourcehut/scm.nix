{
  lib,
  fetchFromSourcehut,
  buildPythonPackage,
  srht,
  pyyaml,
  buildsrht,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "scmsrht";
  version = "0.22.28";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "scm.sr.ht";
    rev = version;
    hash = "sha256-+zxqiz5yPpgTwAw7w8GqJFb3OCcJEH/UhS5u2Xs7pzo=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    srht
    pyyaml
    buildsrht
  ];

  env.PKGVER = version;

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
