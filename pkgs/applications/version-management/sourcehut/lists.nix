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

buildPythonPackage rec {
  pname = "listssrht";
  version = "0.57.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "lists.sr.ht";
    rev = version;
    sha256 = "sha256-nQZRSTAyTWxcPHrRVCZ5TgcrNgrlxBFc1vRds0cQwA0=";
  };

  listssrht-api = buildGoModule ({
    inherit src version;
    pname = "listssrht-api";
    modRoot = "api";
    vendorHash = "sha256-E5Zzft9ANJT/nhhCuenZpdo3t9QYLmA+AyDyrbGectE=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; });

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
    maintainers = with maintainers; [ eadwu ];
  };
}
