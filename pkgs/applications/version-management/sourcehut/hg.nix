{ lib
, fetchFromSourcehut
, buildGoModule
, buildPythonPackage
, srht
, python-hglib
, scmsrht
, unidiff
, python
, unzip
, pip
, pythonOlder
, setuptools
}:

let
  version = "0.32.4";
  gqlgen = import ./fix-gqlgen-trimpath.nix { inherit unzip; gqlgenVersion = "0.17.20"; };

  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hg.sr.ht";
    rev = version;
    hash = "sha256-mYkA44c9wy/Iy1h1lXkVpc9gN7rQXFm4T3YBlQ1Dj60=";
    vc = "hg";
  };

  hgsrht-api = buildGoModule ({
    inherit src version;
    pname = "hgsrht-api";
    modRoot = "api";
    vendorHash = "sha256-vuOYpnF3WjA6kOe9MVSuVMhJBQqCmIex+QUBJrP+VDs=";
  } // gqlgen);

  hgsrht-keys = buildGoModule {
    inherit src version;
    pname = "hgsrht-keys";
    modRoot = "hgsrht-keys";
    vendorHash = "sha256-7ti8xCjSrxsslF7/1X/GY4FDl+69hPL4UwCDfjxmJLU=";

    postPatch = ''
      substituteInPlace hgsrht-keys/main.go \
        --replace /var/log/hgsrht-keys /var/log/sourcehut/hgsrht-keys
    '';
  };
in
buildPythonPackage rec {
  inherit src version;
  pname = "hgsrht";

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api hgsrht-keys" ""

    substituteInPlace hgsrht-shell \
      --replace /var/log/hgsrht-shell /var/log/sourcehut/hgsrht-shell
  '';

  nativeBuildInputs = [
    pip
    setuptools
  ];

  propagatedBuildInputs = [
    python-hglib
    scmsrht
    srht
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
    maintainers = with maintainers; [ eadwu christoph-heiss ];
  };
}
