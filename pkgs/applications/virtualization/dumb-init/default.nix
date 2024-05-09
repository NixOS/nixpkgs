{ lib, stdenv, fetchFromGitHub, glibc }:

stdenv.mkDerivation rec {
  pname = "dumb-init";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = pname;
    rev = "v${version}";
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

  meta = with lib; {
    description = "A minimal init system for Linux containers";
    homepage = "https://github.com/Yelp/dumb-init";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
    mainProgram = "dumb-init";
  };
}
