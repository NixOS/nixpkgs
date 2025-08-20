{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  cpio,
  xar,
  darwin,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "macskk";
  version = "1.4.1";

  src = fetchurl {
    url = "https://github.com/mtgto/macSKK/releases/download/${finalAttrs.version}/macSKK-${finalAttrs.version}.dmg";
    hash = "sha256-lLIFVGwt3VDsXRRGczY5VeqUyUgkX+G9tB3SGrO0voM=";
  };

  nativeBuildInputs = [
    _7zz
    cpio
    xar
  ] ++ lib.optionals stdenvNoCC.hostPlatform.isAarch64 [ darwin.autoSignDarwinBinariesHook ];

  unpackPhase = ''
    runHook preUnpack

    7zz x $src
    xar -xf macSKK-${finalAttrs.version}.pkg
    cat app.pkg/Payload | gunzip -dc | cpio -i
    cat dict.pkg/Payload | gunzip -dc | cpio -i

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/Library/{Containers,Input\ Methods}
    mkdir -p "$out/bin"
    cp -a "Library/Input Methods/macSKK.app" "$out/Library/Input Methods/"
    cp -a "Library/Containers/net.mtgto.inputmethod.macSKK" "$out/Library/Containers/"
    ln -s "$out/Library/Input Methods/macSKK.app/Contents/MacOS/macSKK" "$out/bin/macSKK"

    runHook postInstall
  '';

  meta = {
    description = "Yet Another macOS SKK Input Method";
    homepage = "https://github.com/mtgto/macSKK";
    changelog = "https://github.com/mtgto/macSKK/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wattmto ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "macSKK";
  };
})
