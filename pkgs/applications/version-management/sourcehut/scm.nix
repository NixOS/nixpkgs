{ lib
, fetchFromSourcehut
, buildPythonPackage
, srht
, redis
, pyyaml
, buildsrht
}:

buildPythonPackage rec {
  pname = "scmsrht";
  version = "0.22.16"; # Untagged version

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "scm.sr.ht";
    rev = version;
    sha256 = "sha256-A4Q7wUc4ag7KRWOkdYXCsbzuFHyJJsM15OjrCoVt9UQ=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    redis
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
    description = "Shared support code for sr.ht source control services.";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
