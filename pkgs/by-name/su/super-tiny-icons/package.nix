{
  pkgs,
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "super-tiny-icons";
<<<<<<< HEAD
  version = "0-unstable-2025-10-30";
=======
  version = "unstable-2023-11-06";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "edent";
    repo = "SuperTinyIcons";
<<<<<<< HEAD
    rev = "621ddf6c231d142cccaa411c3c29001404550624";
    hash = "sha256-qx3Z64id5kv/OrfEqI77ovGf2X4uHt6wlZrlUo8Nnb0=";
=======
    rev = "888f449af8fb8df93241204e99fece85b9d225a5";
    hash = "sha256-L/7CEvG0NPbF8+ysiEHPiPnCMAW3cUu/e3XwtatRdbg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/SuperTinyIcons
    find $src/images -type d -exec cp -r {} $out/share/icons/SuperTinyIcons/ \;

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Miniscule SVG versions of common logos";
    longDescription = ''
      Super Tiny Web Icons are minuscule SVG versions of your favourite logos.
      The average size is under 568 bytes!
    '';
    homepage = "https://github.com/edent/SuperTinyIcons";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.h7x4 ];
    platforms = lib.platforms.all;
=======
    license = licenses.mit;
    maintainers = [ maintainers.h7x4 ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
