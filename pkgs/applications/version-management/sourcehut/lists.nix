{ lib
, fetchFromSourcehut
, buildGoModule
, buildPythonPackage
, srht
, aiosmtpd
, asyncpg
, pygit2
, emailthreads
, python
, unzip
, pip
, pythonOlder
, setuptools
}:

let
  version = "0.57.14";
  gqlgen = import ./fix-gqlgen-trimpath.nix { inherit unzip; gqlgenVersion = "0.17.36"; };

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "lists.sr.ht";
    rev = version;
    hash = "sha256-rzOxlat7Lbgt0Wl6vvnAC+fS3MynFVKFvVdIdxgA5e0=";
  };

  listssrht-api = buildGoModule ({
    inherit src version;
    pname = "listssrht-api";
    modRoot = "api";
    vendorHash = "sha256-OWgrPvXVlvJPcoABP0ZxKzoYFhU44j/I44sBBRbd6KY=";
  } // gqlgen);
in
buildPythonPackage rec {
  inherit src version;
  pname = "listssrht";
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
    aiosmtpd
    asyncpg
    pygit2
    # Unofficial dependency
    emailthreads
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  postInstall = ''
    ln -s ${listssrht-api}/bin/api $out/bin/listssrht-api
  '';

  pythonImportsCheck = [ "listssrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/lists.sr.ht";
    description = "Mailing list service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu christoph-heiss ];
  };
}
