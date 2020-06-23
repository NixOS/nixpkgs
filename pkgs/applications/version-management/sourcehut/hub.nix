{ stdenv, fetchgit, buildPythonPackage
, python
, srht }:

buildPythonPackage rec {
  pname = "hubsrht";
  version = "0.10.6";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/hub.sr.ht";
    rev = version;
    sha256 = "N54GOk9pxwoF1Wv0ZSe4kIAPBLl/zHrSu8OlKBkacVg=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  meta = with stdenv.lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hub.sr.ht";
    description = "Project hub service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
