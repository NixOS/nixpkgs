{ lib
, fetchFromSourcehut
, buildPythonPackage
, srht
, pygit2
, python
, buildGoModule
, unzip
}:

buildPythonPackage rec {
  pname = "mansrht";
  version = "0.16.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "man.sr.ht";
    rev = version;
    sha256 = "sha256-QxM9WwqvWyqHfck+P+CMoQ2p+8ZdbO8KOJ9qa40nsWI=";
  };

  mansrht-api = buildGoModule ({
    inherit src version;
    pname = "mansrht-api";
    modRoot = "api";
    vendorSha256 = "sha256-K5EmZ4U+xItTR85+SCwhwg5KUGLkKHo9Nr2pkvmJpfo=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; });

  propagatedBuildInputs = [
    srht
    pygit2
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api" ""
  '';

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  postInstall = ''
    mkdir -p $out/bin $out/share/sql
    cp schema.sql $out/share/sql/man-schema.sql
    ln -s ${mansrht-api}/bin/api $out/bin/mansrht-api
  '';

  pythonImportsCheck = [ "mansrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/man.sr.ht";
    description = "Wiki service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
