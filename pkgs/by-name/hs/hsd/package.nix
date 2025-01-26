{ lib
, stdenv
, buildNpmPackage
, fetchFromGitHub
, python3
, unbound
, cctools
}:

buildNpmPackage rec {
  pname = "hsd";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "handshake-org";
    repo = "hsd";
    rev = "v${version}";
    hash = "sha256-bmvoykpaYQDWLYKOwgKZ1V6ivzDJFM1Yo+ATkzKTP2s=";
  };

  npmDepsHash = "sha256-qM1oPTKffJHlHWhF5huCBPmBSajiYstjhC2GB/iMQ7E=";

  nativeBuildInputs = [
    python3
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
  ];

  buildInputs = [
    unbound
  ];

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/handshake-org/hsd/blob/${src.rev}/CHANGELOG.md";
    description = "Implementation of the Handshake protocol";
    homepage = "https://github.com/handshake-org/hsd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ d-xo ];
  };
}
