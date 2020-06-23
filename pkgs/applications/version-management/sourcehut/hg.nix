{ stdenv, fetchhg, buildPythonPackage
, python
, srht, hglib, scmsrht, unidiff }:

buildPythonPackage rec {
  pname = "hgsrht";
  version = "0.26.18";

  src = fetchhg {
    url = "https://hg.sr.ht/~sircmpwn/hg.sr.ht";
    rev = version;
    sha256 = "j+7yG6WdWoU0Uk6doz9GpKZsEGXy/n2smgU6c56/A+Q=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    hglib
    scmsrht
    unidiff
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  meta = with stdenv.lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hg.sr.ht";
    description = "Mercurial repository hosting service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
