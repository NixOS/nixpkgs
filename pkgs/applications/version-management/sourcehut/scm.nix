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
  version = "0.22.22";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "scm.sr.ht";
    rev = version;
    sha256 = "sha256-iSzzyI8HZOpOb4dyt520MV/wds14fNag2+UOF09KS7w=";
  };

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
