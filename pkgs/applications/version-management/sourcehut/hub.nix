{ lib
, fetchFromSourcehut
, buildPythonPackage
, srht
}:

buildPythonPackage rec {
  pname = "hubsrht";
  version = "0.13.1";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hub.sr.ht";
    rev = version;
    sha256 = "sha256-Kqzy4mh5Nn1emzHBco/LVuXro/tW3NX+OYqdEwBSQ/U=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hub.sr.ht";
    description = "Project hub service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
