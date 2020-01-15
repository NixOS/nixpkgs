{ stdenv, fetchgit, buildPythonPackage
, python
, srht, pyyaml, PyGithub, cryptography }:

buildPythonPackage rec {
  pname = "dispatchsrht";
  version = "0.11.0";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/dispatch.sr.ht";
    rev = version;
    sha256 = "1kahl2gy5a5li79djwkzkglkw2s7pl4d29bzqp8c53r0xvx4sqkz";
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
