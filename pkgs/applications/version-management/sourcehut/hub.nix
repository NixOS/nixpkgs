{ lib
, fetchFromSourcehut
, buildPythonPackage
, srht
, pyyaml
}:

buildPythonPackage rec {
  pname = "hubsrht";
  version = "0.14.14";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hub.sr.ht";
    rev = version;
    sha256 = "sha256-4n6oQ+AAvdJY/5KflxAp62chjyrlSUkmt319DKZk33w=";
  };

  propagatedBuildInputs = [
    srht
    pyyaml
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  dontUseSetuptoolsCheck = true;
  pythonImportsCheck = [ "hubsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hub.sr.ht";
    description = "Project hub service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
