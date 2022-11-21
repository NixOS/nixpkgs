{ lib
, fetchFromSourcehut
, buildPythonPackage
, srht
, pyyaml
, python
, buildGoModule
, unzip
}:

buildPythonPackage rec {
  pname = "pastesrht";
  version = "0.15.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "paste.sr.ht";
    rev = version;
    sha256 = "sha256-FyajvzPPHPdXwJNwHip1nBe7ryNP3dXwV59bUcrglWU=";
  };

  pastesrht-api = buildGoModule ({
    inherit src version;
    pname = "pastesrht-api";
    modRoot = "api";
    vendorSha256 = "sha256-jiE73PUPSHxtWp7XBdH4mJw95pXmZjCl4tk2wQUf2M4=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; });

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api" ""
  '';

  propagatedBuildInputs = [
    srht
    pyyaml
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  postInstall = ''
    mkdir -p $out/bin $out/share/sql
    cp schema.sql $out/share/sql/paste-schema.sql
    ln -s ${pastesrht-api}/bin/api $out/bin/pastesrht-api
  '';

  pythonImportsCheck = [ "pastesrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/paste.sr.ht";
    description = "Ad-hoc text file hosting service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
