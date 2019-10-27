{ stdenv, fetchgit, buildPythonPackage
, python
, srht, pyyaml, PyGithub, cryptography }:

buildPythonPackage rec {
  pname = "dispatchsrht";
  version = "0.11.1";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/dispatch.sr.ht";
    rev = version;
    sha256 = "1bi7vn0yr326mf2c63f2fahdlrx2c6a8d6p6bzy2ym2835qfcc0v";
  };

  patches = [
    ./use-srht-path.patch
  ];

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    pyyaml
    PyGithub
    cryptography
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  meta = with stdenv.lib; {
    homepage = https://dispatch.sr.ht/~sircmpwn/dispatch.sr.ht;
    description = "Task dispatcher and service integration tool for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
