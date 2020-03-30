{ stdenv, fetchgit, buildPythonPackage
, python
, srht, pygit2 }:

buildPythonPackage rec {
  pname = "mansrht";
  version = "0.14.1";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/man.sr.ht";
    rev = version;
    sha256 = "13yar0sa24jyiq0l4p4bgq6p5crj148f26sxwyi37g76jqba4rfi";
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
