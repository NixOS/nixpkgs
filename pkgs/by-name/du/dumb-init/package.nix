{
  lib,
  stdenv,
  fetchFromGitHub,
  glibc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dumb-init";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = "dumb-init";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-aRh0xfmp+ToXIYjYaducTpZUHndZ5HlFZpFhzJ3yKgs=";
  };

  postPatch = lib.optionalString (!stdenv.hostPlatform.isStatic) ''
    substituteInPlace Makefile --replace "-static" ""
  '';

  buildInputs = lib.optional (stdenv.hostPlatform.isGnu && stdenv.hostPlatform.isStatic) glibc.static;

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin dumb-init

    runHook postInstall
  '';

  meta = {
    description = "Minimal init system for Linux containers";
    homepage = "https://github.com/Yelp/dumb-init";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "dumb-init";
  };
})
