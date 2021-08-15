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
  version = "0.27.6";

  src = fetchhg {
    url = "https://hg.sr.ht/~sircmpwn/hg.sr.ht";
    rev = version;
    sha256 = "ibijvKjS4CiWTYrO6Qdh3RkD0EUE7BY8wjdPwrD6vkA=";
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

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hg.sr.ht";
    description = "Mercurial repository hosting service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
