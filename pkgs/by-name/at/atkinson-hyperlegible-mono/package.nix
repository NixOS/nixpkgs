{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "atkinson-hyperlegible-mono";
  version = "2.001-unstable-2024-11-20";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "atkinson-hyperlegible-next-mono";
    rev = "154d50362016cc3e873eb21d242cd0772384c8f9";
    hash = "sha256-V0zWbNYT3RGO9vjX+GHfO38ywMozcZVJkBZH+8G5sC0=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/opentype fonts/otf/*
    install -Dm644 -t $out/share/fonts/variable fonts/variable/*

    runHook postInstall
  '';

  meta = {
    description = "New (2024) monospace sibling family to Atkinson Hyperlegible Next";
    homepage = "https://www.brailleinstitute.org/freefont/";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.all;
  };
}
