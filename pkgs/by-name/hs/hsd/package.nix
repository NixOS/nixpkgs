{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  unbound,
  cctools,
}:

buildNpmPackage rec {
  pname = "hsd";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "handshake-org";
    repo = "hsd";
    rev = "v${version}";
    hash = "sha256-7hF8cJf9Oewfg5WvNpqQSrBZjpnERcdDAaxixOdArpo=";
  };

  npmDepsHash = "sha256-fO8ia0FwNvMMVBUO22gUNImkXY3kjdUjQIP7s5MOJDs=";

  nativeBuildInputs = [
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
  };
}
