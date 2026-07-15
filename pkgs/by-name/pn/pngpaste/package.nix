{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pngpaste";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "jcsalterego";
    repo = "pngpaste";
    tag = finalAttrs.version;
    sha256 = "uvajxSelk1Wfd5is5kmT2fzDShlufBgC0PDCeabEOSE=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm555 pngpaste $out/bin/pngpaste
    runHook postInstall
  '';

  meta = {
    description = "Paste image files from clipboard to file on MacOS";
    longDescription = ''
      Paste PNG into files on MacOS, much like pbpaste does for text.
      Supported input formats are PNG, PDF, GIF, TIF, JPEG.
      Supported output formats are PNG, GIF, JPEG, TIFF.  Output
      formats are determined by the provided filename extension,
      falling back to PNG.
    '';
    homepage = "https://github.com/jcsalterego/pngpaste";
    changelog = "https://github.com/jcsalterego/pngpaste/raw/${finalAttrs.version}/CHANGELOG.md";
    platforms = lib.platforms.darwin;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ samw ];
  };
})
