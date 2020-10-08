{ stdenv, fetchgit, buildPythonPackage
, python
, srht, pygit2 }:

buildPythonPackage rec {
  pname = "mansrht";
  version = "0.15.1";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/man.sr.ht";
    rev = version;
    sha256 = "hCpuVngpu2AacFGn0F78k2qrn09Z/p1rP8vfW7gkzWc=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    pygit2
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  meta = with stdenv.lib; {
    homepage = "https://git.sr.ht/~sircmpwn/man.sr.ht";
    description = "Wiki service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
