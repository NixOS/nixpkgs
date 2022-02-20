{ lib
, fetchhg
, buildPythonPackage
, srht
, hglib
, scmsrht
, unidiff
, python
}:

buildPythonPackage rec {
  pname = "hgsrht";
  version = "0.29.4";

  src = fetchhg {
    url = "https://hg.sr.ht/~sircmpwn/hg.sr.ht";
    rev = version;
    sha256 = "Jn9M/R5tJK/GeJDWGo3LWCK2nwsfI9zh+/yo2M+X6Sk=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    hglib
    scmsrht
    unidiff
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  pythonImportsCheck = [ "hgsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hg.sr.ht";
    description = "Mercurial repository hosting service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
