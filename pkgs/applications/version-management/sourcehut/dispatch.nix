{ stdenv, fetchgit, buildPythonPackage
, python
, srht, pyyaml, PyGithub }:

buildPythonPackage rec {
  pname = "dispatchsrht";
  version = "0.13.3";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/dispatch.sr.ht";
    rev = version;
    sha256 = "08asayfwpzafscpli5grx1p0y1ryz7pqkznf5bd9j8ir2iyhbc10";
  };

  patches = [
    ./use-srht-path.patch
  ];

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

  meta = with stdenv.lib; {
    homepage = https://dispatch.sr.ht/~sircmpwn/dispatch.sr.ht;
    description = "Task dispatcher and service integration tool for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
