{
  lib,
  stdenvNoCC,
  _7zz,
  fetchurl,
  makeBinaryWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  src = fetchurl {
    url = "https://release.files.ghostty.org/${finalAttrs.version}/Ghostty.dmg";
    hash = "sha256-CR96Kz9BYKFtfVKygiEku51XFJk4FfYqfXACeYQ3JlI=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    _7zz
    makeBinaryWrapper
  ];

  postInstall = ''
    mkdir -p $out/Applications
    mv Ghostty.app $out/Applications/
    makeWrapper $out/Applications/Ghostty.app/Contents/MacOS/ghostty $out/bin/ghostty
  '';

  # For use in our shared postFixup
  resourceDir = "${placeholder "out"}/Applications/Ghostty.app/Contents/Resources";

  # Usually the multiple-outputs hook would take care of this, but
  # our manpages are in the .app bundle
  preFixup = ''
    mkdir -p $man/share
    mv $resourceDir/man $man/share/man
  '';

  meta = {
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
