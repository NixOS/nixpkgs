{ stdenv, fetchgit, buildPythonPackage
, python
, srht, pyyaml }:

buildPythonPackage rec {
  pname = "pastesrht";
  version = "0.5.2";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/paste.sr.ht";
    rev = version;
    sha256 = "16d0qviw3qifyqn94fj03mwxd65abf8bhrvn1fn6ramaq8zpx794";
  };

  patches = [
    ./use-srht-path.patch
  ];

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    pyyaml
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  meta = with stdenv.lib; {
    homepage = https://git.sr.ht/~sircmpwn/paste.sr.ht;
    description = "Ad-hoc text file hosting service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
