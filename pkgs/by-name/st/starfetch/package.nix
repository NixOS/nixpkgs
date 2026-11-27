{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "starfetch";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "Haruno19";
    repo = "starfetch";
    rev = finalAttrs.version;
    sha256 = "sha256-Wv8rkNvBs1lkAYFI1fzP9ZEE9lkX0OCFazFNO+COMxY=";
  };

  postPatch = ''
    substituteInPlace src/starfetch.cpp --replace-fail /usr/local/ $out/
  ''
  + lib.optionalString stdenv.cc.isClang ''
    substituteInPlace makefile --replace-warn g++ clang++
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/starfetch
    cp starfetch $out/bin/
    cp -r res/* $out/share/starfetch/

    runHook postInstall
  '';

  meta = {
    description = "CLI star constellations displayer";
    homepage = "https://github.com/Haruno19/starfetch";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ annaaurora ];
    mainProgram = "starfetch";
  };
})
