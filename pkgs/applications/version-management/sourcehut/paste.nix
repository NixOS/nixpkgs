{ lib
, fetchFromSourcehut
, buildGoModule
, buildPythonPackage
, srht
, pip
, pyyaml
, python
, pythonOlder
, setuptools
, unzip
}:

let
  version = "0.15.2";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "paste.sr.ht";
    rev = version;
    sha256 = "sha256-ZZzcd14Jbo1MfET7B56X/fl9xWXpCJ8TuKrGVgJwZfQ=";
  };

  pastesrht-api = buildGoModule ({
    inherit src version;
    pname = "pastesrht-api";
    modRoot = "api";
    vendorHash = "sha256-jiE73PUPSHxtWp7XBdH4mJw95pXmZjCl4tk2wQUf2M4=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; });
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
    maintainers = with maintainers; [ eadwu nessdoor ];
  };
}
