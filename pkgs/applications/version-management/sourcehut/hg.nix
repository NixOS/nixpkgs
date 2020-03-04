{ stdenv, fetchhg, buildPythonPackage
, python
, srht, hglib, scmsrht, unidiff }:

buildPythonPackage rec {
  pname = "hgsrht";
  version = "0.21.1";

  src = fetchhg {
    url = "https://hg.sr.ht/~sircmpwn/hg.sr.ht";
    rev = version;
    sha256 = "19r8zcy4xf9imqifqw3b7ylxd46i025ncns69kn5xp11damilz66";
  };

  patches = [
    ./use-srht-path.patch
  ];

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

  meta = with stdenv.lib; {
    homepage = https://git.sr.ht/~sircmpwn/hg.sr.ht;
    description = "Mercurial repository hosting service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
