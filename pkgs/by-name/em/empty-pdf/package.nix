{
  stdenvNoCC,
  imagemagick,
  lib,
}:

stdenvNoCC.mkDerivation {
  name = "empty-pdf";

  __structuredAttrs = true;
  strictDeps = true;

  dontUnpack = true;

  nativeBuildInputs = [ imagemagick ];

  buildPhase = ''
    runHook preBuild

    magick xc:none -page Letter empty.pdf

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mv empty.pdf $out

    runHook postInstall
  '';

  meta = {
    description = "Empty PDF file intended for testing";
    maintainers = with lib.maintainers; [
      pandapip1
      thefossguy
    ];
    platforms = imagemagick.meta.platforms;
  };
}
