{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oppai-ng";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "Francesco149";
    repo = "oppai-ng";
    rev = finalAttrs.version;
    sha256 = "sha256-L9eraLOWm1tMImS8bLB9T4Md4VdTSxqI9Bt4r8eqxqs=";
  };

  buildPhase = ''
    ./build
    ./libbuild
  '';

  installPhase = ''
    install -D oppai $out/bin/oppai
    install -D oppai.c $out/include/oppai.c
    install -D liboppai.so $out/lib/liboppai.so
  '';

  meta = {
    description = "Difficulty and pp calculator for osu!";
    homepage = "https://github.com/Francesco149/oppai-ng";
    license = lib.licenses.unlicense;
    maintainers = [ ];
    mainProgram = "oppai";
    platforms = lib.platforms.all;
  };
})
