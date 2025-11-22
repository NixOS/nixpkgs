{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "mkbootimg-osm0sis";
  version = "2022.11.09-unstable-2025-03-10";

  src = fetchFromGitHub {
    owner = "osm0sis";
    repo = "mkbootimg";
    rev = "17cea80bd5af64e45cdf9e263cad7555030e0e86";
    hash = "sha256-5ilpgQS5ctMpxTJRa8Wty1B0mNN+77/fS2FThNfAKZk=";
  };

  strictDeps = true;

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optional stdenv.cc.isGNU [
      # Required with newer GCC
      "-Wno-error=stringop-overflow"
    ]
  );

  installPhase = ''
    runHook preInstall
    install -Dm555 {mk,unpack}bootimg -t $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/osm0sis/mkbootimg";
    description = "osm0sis's mkbootimg & unpackbootimg";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "mkbootimg";
  };
}
