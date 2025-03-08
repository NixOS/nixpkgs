{
  stdenvNoCC,
  fetchurl,
  lib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sparkle";
  version = "2.6.4";

  src = fetchurl {
    url = "https://github.com/sparkle-project/Sparkle/releases/download/${finalAttrs.version}/Sparkle-${finalAttrs.version}.tar.xz";
    hash = "sha256-UGEqBgOKvJMfFgEdeQO4Mmo2LBB02rzLcYQEzo5YXws=";
  };

  sourceRoot = ".";

  buildPhase = ''
    mkdir -p "$out"/Applications

    # Link sparkle-cli binary from sparkle.app
    ln -s ../Applications/sparkle.app/Contents/MacOS/sparkle bin/sparkle

    # Move "bin/old_dsa_scripts/sign_update" to "bin/sign_update_dsa"
    mv bin/old_dsa_scripts/sign_update bin/sign_update_dsa
    rm -rf bin/old_dsa_scripts

    mv sparkle.app "Sparkle Test App.app" "$out"/Applications
    mv Sparkle.framework bin "$out"
  '';

  meta = {
    description = "Software update framework for macOS";
    homepage = "https://sparkle-project.org/";
    changelog = "https://github.com/sparkle-project/Sparkle/blob/${finalAttrs.version}/CHANGELOG";
    platforms = lib.platforms.darwin;
    license = with lib.licenses; [
      mit # Sparkle itself
      bsd2 # bsdiff and SUSignatureVerifier.m
      zlib # ed25519
    ];
    mainProgram = "sparkle";
    maintainers = with lib.maintainers; [ andre4ik3 ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
