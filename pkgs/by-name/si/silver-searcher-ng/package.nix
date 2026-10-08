{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  git,
  pkg-config,
  pcre2,
  python3Packages,
  zlib,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "silver-searcher-ng";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "silver-searcher";
    repo = "silver-searcher-ng";
    rev = finalAttrs.version;
    hash = "sha256-IiVFbS9XGmqcGN4NRXFC07cV6bGKDs9C2y5XxJKdvFk=";
  };

  patches = [ ./bash-completion.patch ];

  env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    NIX_LDFLAGS = "-lgcc_s";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    pcre2
    zlib
    xz
  ];

  doCheck = true;
  nativeCheckInputs = [
    python3Packages.cram
    git
  ];
  checkPhase = ''
    runHook preCheck

    make test

    runHook postCheck
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/silver-searcher/silver-searcher-ng";
    description = "Code-searching tool similar to ack, but faster";
    maintainers = with lib.maintainers; [ timschumi ];
    mainProgram = "ag";
    platforms = lib.platforms.all;
    license = lib.licenses.asl20;
  };
})
