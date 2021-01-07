{ stdenv, fetchgit, buildPythonPackage
, python
, srht, pygit2 }:

buildPythonPackage rec {
  pname = "mansrht";
  version = "0.15.4";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/man.sr.ht";
    rev = version;
    sha256 = "0spi0yy2myxw4kggy54yskda14c4vaq2ng9dd9krqsajnsy7anrw";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    pygit2
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  dontUseSetuptoolsCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://git.sr.ht/~sircmpwn/man.sr.ht";
    description = "Wiki service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
