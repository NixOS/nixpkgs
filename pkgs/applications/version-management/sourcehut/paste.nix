{ stdenv, fetchgit, buildPythonPackage
, python
, srht, pyyaml }:

buildPythonPackage rec {
  pname = "pastesrht";
  version = "0.11.1";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/paste.sr.ht";
    rev = version;
    sha256 = "vk+h9gQX9KeynjulDaK/vHpKeRQAjVyxk7ttKG27ZIo=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    pyyaml
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  meta = with stdenv.lib; {
    homepage = "https://git.sr.ht/~sircmpwn/paste.sr.ht";
    description = "Ad-hoc text file hosting service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
