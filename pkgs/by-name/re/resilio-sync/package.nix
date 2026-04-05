{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  installShellFiles,
  libxcrypt-legacy,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "resilio-sync";
  version = "3.1.1.1075";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://download-cdn.resilio.com/${finalAttrs.version}/linux/x64/0/resilio-sync_x64.tar.gz";
        hash = "sha256-FgRMK5dOxkbaXyi0BPYQZK0tR/ZZuuUGAciwThqICBk=";
      };

      aarch64-linux = fetchurl {
        url = "https://download-cdn.resilio.com/${finalAttrs.version}/linux/arm64/0/resilio-sync_arm64.tar.gz";
        hash = "sha256-P3gUwj3Vr9qn9S6iqlgGfZpK7x5u4U96b886JCE3CYY=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  dontStrip = true; # Don't strip, otherwise patching the rpaths breaks
  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    installShellFiles
  ];

  buildInputs = [
    stdenv.cc.libc
    libxcrypt-legacy
  ];

  installPhase = ''
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
      thoughtpolice
      cwoac
    ];
    mainProgram = "rslsync";
  };
})
