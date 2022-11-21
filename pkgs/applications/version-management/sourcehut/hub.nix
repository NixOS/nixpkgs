{ lib
, fetchFromSourcehut
, buildPythonPackage
, srht
, pyyaml
, buildGoModule
, unzip
}:

buildPythonPackage rec {
  pname = "hubsrht";
  version = "0.16.1";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hub.sr.ht";
    rev = version;
    sha256 = "sha256-ivQ7bJhZyBl6aoMUCoLNkDQ/WcSlpGaTuP8TbjSn8ek=";
  };

  hubsrht-api = buildGoModule ({
    inherit src version;
    pname = "hubsrht-api";
    modRoot = "api";
    vendorSha256 = "sha256-K5EmZ4U+xItTR85+SCwhwg5KUGLkKHo9Nr2pkvmJpfo=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; });

  propagatedBuildInputs = [
    srht
    pyyaml
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api" ""
  '';

  preBuild = ''
    export PKGVER=${version}
  '';

  postInstall = ''
    mkdir -p $out/bin $out/share/sql
    cp schema.sql $out/share/sql/hub-schema.sql
    ln -s ${hubsrht-api}/bin/api $out/bin/hubsrht-api
  '';

  dontUseSetuptoolsCheck = true;
  pythonImportsCheck = [ "hubsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hub.sr.ht";
    description = "Project hub service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
