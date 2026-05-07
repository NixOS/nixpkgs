{
  pkgs,
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "super-tiny-icons";
  version = "0-unstable-2025-10-30";

  src = fetchFromGitHub {
    owner = "edent";
    repo = "SuperTinyIcons";
    rev = "621ddf6c231d142cccaa411c3c29001404550624";
    hash = "sha256-qx3Z64id5kv/OrfEqI77ovGf2X4uHt6wlZrlUo8Nnb0=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/SuperTinyIcons
    find $src/images -type d -exec cp -r {} $out/share/icons/SuperTinyIcons/ \;

    runHook postInstall
  '';

  meta = {
    description = "Miniscule SVG versions of common logos";
    longDescription = ''
      Super Tiny Web Icons are minuscule SVG versions of your favourite logos.
      The average size is under 568 bytes!
    '';
    homepage = "https://github.com/edent/SuperTinyIcons";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.h7x4 ];
    platforms = lib.platforms.all;
  };
}
