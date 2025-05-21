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
  setuptools-scm,
  unzip,
}:

let
  version = "0.16.1";
  gqlgen = import ./fix-gqlgen-trimpath.nix {
    inherit unzip;
    gqlgenVersion = "0.17.64";
  };

  patches = [ ./patches/core-go-update/paste/patch-deps.patch ];

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "paste.sr.ht";
    rev = version;
    hash = "sha256-SWtkE2/sTTJo0zAVFRfsA7fVF359OvgiHOT+yRaiads=";
  };

  pastesrht-api = buildGoModule (
    {
      inherit src version patches;
      pname = "pastesrht-api";
      modRoot = "api";
      vendorHash = "sha256-uVqxPa1YggPgdSzGzXxVNdf4dM2DPGDXajkSXz4NhFM=";
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  inherit src version patches;
  pname = "pastesrht";
  pyproject = true;

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [
    pip
    setuptools-scm
  ];

  propagatedBuildInputs = [
    srht
    pyyaml
  ];

  env = {
    PKGVER = version;
    SRHT_PATH = "${srht}/${python.sitePackages}/srht";
    PREFIX = placeholder "out";
  };

  postBuild = ''
    make SASSC_INCLUDE=-I${srht}/share/sourcehut/scss/ all-share
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s ${pastesrht-api}/bin/api $out/bin/paste.sr.ht-api
    make install-share
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
