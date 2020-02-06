{ stdenv, fetchgit, buildPythonPackage
, python
, srht, pyyaml }:

buildPythonPackage rec {
  pname = "pastesrht";
  version = "0.7.3";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/paste.sr.ht";
    rev = version;
    sha256 = "15689gk37djcwdjb636d97k0il2zpdpksb95l9l4d43wipd7x5qi";
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
