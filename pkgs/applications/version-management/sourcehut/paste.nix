{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  buildPythonPackage,
  srht,
  pip,
  pyyaml,
  python,
  pythonOlder,
  setuptools,
  unzip,
}:

let
  version = "0.15.4";
  gqlgen = import ./fix-gqlgen-trimpath.nix {
    inherit unzip;
    gqlgenVersion = "0.17.45";
  };

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "paste.sr.ht";
    rev = version;
    hash = "sha256-M38hAMRdMzcqxJv7j7foOIYEImr/ZYz/lbYOF9R9g2M=";
  };

  pastesrht-api = buildGoModule (
    {
      inherit src version;
      pname = "pastesrht-api";
      modRoot = "api";
      vendorHash = "sha256-vt5nSPcx+Y/SaWcqjV38DTL3ZtzmdjbkJYMv5Fhhnq4=";
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  inherit src version;
  pname = "pastesrht";
  pyproject = true;

  disabled = pythonOlder "3.7";

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api" ""
  '';

  nativeBuildInputs = [
    pip
    setuptools
  ];

  propagatedBuildInputs = [
    srht
    pyyaml
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s ${pastesrht-api}/bin/api $out/bin/pastesrht-api
  '';

  pythonImportsCheck = [ "pastesrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/paste.sr.ht";
    description = "Ad-hoc text file hosting service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      eadwu
      nessdoor
      christoph-heiss
    ];
  };
}
