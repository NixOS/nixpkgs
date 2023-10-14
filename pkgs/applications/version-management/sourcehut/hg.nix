{ lib
, fetchFromSourcehut
, buildGoModule
, buildPythonPackage
, srht
, hglib
, scmsrht
, unidiff
, python
, unzip
}:

buildPythonPackage rec {
  pname = "hgsrht";
  version = "0.31.3";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hg.sr.ht";
    rev = version;
    sha256 = "4Qe08gqsSTMQVQBchFPEUXuxM8ZAAQGJT1EOcDjkZa0=";
    vc = "hg";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api hgsrht-keys" ""
  '';

  hgsrht-api = buildGoModule ({
    inherit src version;
    pname = "hgsrht-api";
    modRoot = "api";
    vendorHash = "sha256-uIP3W7UJkP68HJUF33kz5xfg/KBiaSwMozFYmQJQkys=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; });

  hgsrht-keys = buildGoModule {
    inherit src version;
    pname = "hgsrht-keys";
    modRoot = "hgsrht-keys";
    vendorHash = "sha256-7ti8xCjSrxsslF7/1X/GY4FDl+69hPL4UwCDfjxmJLU=";
  };

  propagatedBuildInputs = [
    srht
    hglib
    scmsrht
    unidiff
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  postInstall = ''
    ln -s ${hgsrht-api}/bin/api $out/bin/hgsrht-api
    ln -s ${hgsrht-keys}/bin/hgsrht-keys $out/bin/hgsrht-keys
  '';

  pythonImportsCheck = [ "hgsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hg.sr.ht";
    description = "Mercurial repository hosting service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
