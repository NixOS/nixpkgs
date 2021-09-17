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
  version = "0.27.4";

  src = fetchhg {
    url = "https://hg.sr.ht/~sircmpwn/hg.sr.ht";
    rev = version;
    sha256 = "1c0qfi0gmbfngvds6917fy9ii2iglawn429757rh7b4bvzn7n6mr";
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
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
