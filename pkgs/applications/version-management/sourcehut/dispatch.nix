{ lib
, fetchFromSourcehut
, buildPythonPackage
, srht
, pyyaml
, PyGithub
, python
}:

buildPythonPackage rec {
  pname = "dispatchsrht";
  version = "0.15.8";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "dispatch.sr.ht";
    rev = version;
    sha256 = "sha256-zWCGPjIgMKHXHJUs9aciV7IFgo0rpahon6KXHDwcfss=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    pyyaml
    PyGithub
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  meta = with lib; {
    homepage = "https://dispatch.sr.ht/~sircmpwn/dispatch.sr.ht";
    description = "Task dispatcher and service integration tool for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
