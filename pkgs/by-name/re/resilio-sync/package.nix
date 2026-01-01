{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
<<<<<<< HEAD
  installShellFiles,
  libxcrypt-legacy,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "resilio-sync";
  version = "3.1.1.1075";
=======
  libxcrypt-legacy,
}:

stdenv.mkDerivation rec {
  pname = "resilio-sync";
  version = "3.0.2.1058";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src =
    {
      x86_64-linux = fetchurl {
<<<<<<< HEAD
        url = "https://download-cdn.resilio.com/${finalAttrs.version}/linux/x64/0/resilio-sync_x64.tar.gz";
        hash = "sha256-FgRMK5dOxkbaXyi0BPYQZK0tR/ZZuuUGAciwThqICBk=";
      };

      aarch64-linux = fetchurl {
        url = "https://download-cdn.resilio.com/${finalAttrs.version}/linux/arm64/0/resilio-sync_arm64.tar.gz";
        hash = "sha256-P3gUwj3Vr9qn9S6iqlgGfZpK7x5u4U96b886JCE3CYY=";
=======
        url = "https://download-cdn.resilio.com/${version}/linux/x64/0/resilio-sync_x64.tar.gz";
        hash = "sha256-jdkxSN/JscL2hxIWuShNKyUk28d453LPDM/+FtzquGQ=";
      };

      aarch64-linux = fetchurl {
        url = "https://download-cdn.resilio.com/${version}/linux/arm64/0/resilio-sync_arm64.tar.gz";
        hash = "sha256-iczg1jEy+49QczKxc0/UZJ8LPaCHsXKmSrudVb3RWZ8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  dontStrip = true; # Don't strip, otherwise patching the rpaths breaks
  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
<<<<<<< HEAD
    installShellFiles
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  buildInputs = [
    stdenv.cc.libc
    libxcrypt-legacy
  ];

  installPhase = ''
<<<<<<< HEAD
    runHook preInstall

    installBin rslsync

    runHook postInstall
  '';

  meta = {
    description = "Automatically sync files via secure, distributed technology";
    homepage = "https://www.resilio.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
=======
    install -D rslsync "$out/bin/rslsync"
  '';

  meta = with lib; {
    description = "Automatically sync files via secure, distributed technology";
    homepage = "https://www.resilio.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      thoughtpolice
      cwoac
    ];
    mainProgram = "rslsync";
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
