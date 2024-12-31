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
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "handshake-org";
    repo = "hsd";
    rev = "v${version}";
    hash = "sha256-Rsa4LTf5lImvCwwuu0FKbBb/QLLAbR8Vce/pWEQLhS0=";
  };

  npmDepsHash = "sha256-7zD0noREaq/VNQrf/9dOFXVOngcS6G4mHZAkyQLs/1Q=";

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
