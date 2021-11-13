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
  version = "0.28.1";

  src = fetchhg {
    url = "https://hg.sr.ht/~sircmpwn/hg.sr.ht";
    rev = version;
    sha256 = "ERMPaCtExZebwV1BrjyE/gGK7p/Nvf7ia+ZBO472bdw=";
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
