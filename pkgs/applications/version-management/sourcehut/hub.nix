{ lib
, fetchFromSourcehut
, buildPythonPackage
, srht
}:

buildPythonPackage rec {
  pname = "hubsrht";
  version = "0.13.11";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hub.sr.ht";
    rev = version;
    sha256 = "sha256-AIpP7gfXoBvl6s8+dA3XrjuUHsPTtKFsZqwqbjBKYUk=";
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
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
