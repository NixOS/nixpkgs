{ stdenv, fetchgit, buildPythonPackage
, python
, srht, pygit2 }:

buildPythonPackage rec {
  pname = "mansrht";
  version = "0.12.4";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/man.sr.ht";
    rev = version;
    sha256 = "1csnw71yh5zw7l17xmmxyskwiqbls0ynbbjrg45y5k1i3622mhiy";
  };

  patches = [
    ./use-srht-path.patch
  ];

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    pygit2
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  meta = with stdenv.lib; {
    homepage = https://git.sr.ht/~sircmpwn/man.sr.ht;
    description = "Wiki service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
