{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "atkinson-hyperlegible-next";
  version = "2.001-unstable-2025-02-21";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "atkinson-hyperlegible-next";
    rev = "7925f50f649b3813257faf2f4c0b381011f434f1";
    hash = "sha256-LhwfYI5Z6BhO7OaY/RwXT7r3WYiUY9AO2HL3MmhPpQY=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/opentype fonts/otf/*
    install -Dm644 -t $out/share/fonts/variable fonts/variable/*

    runHook postInstall
  '';

  meta = {
    description = "New (2024) second version of the Atkinson Hyperlegible fonts";
    homepage = "https://www.brailleinstitute.org/freefont/";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.all;
  };
}
