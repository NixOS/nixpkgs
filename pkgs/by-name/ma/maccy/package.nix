{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "maccy";
<<<<<<< HEAD
  version = "2.6.1";

  src = fetchurl {
    url = "https://github.com/p0deje/Maccy/releases/download/${finalAttrs.version}/Maccy.app.zip";
    hash = "sha256-hLlbrxlhvfMARRiMhVI3+QwUJqyPEjtK6PdBkfnzhoI=";
=======
  version = "2.5.1";

  src = fetchurl {
    url = "https://github.com/p0deje/Maccy/releases/download/${finalAttrs.version}/Maccy.app.zip";
    hash = "sha256-pwMiCAS+1uEtEQv2e1UflxYuuh/qqYJbMcp2ZVvZBTA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    unzip -d $out/Applications $src

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Simple clipboard manager for macOS";
    homepage = "https://maccy.app";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      emilytrau
      baongoc124
    ];
    platforms = lib.platforms.darwin;
=======
  meta = with lib; {
    description = "Simple clipboard manager for macOS";
    homepage = "https://maccy.app";
    license = licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [
      emilytrau
      baongoc124
    ];
    platforms = platforms.darwin;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
