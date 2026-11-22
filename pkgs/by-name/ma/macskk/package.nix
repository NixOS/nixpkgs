{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  cpio,
  xar,
  darwin,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "macskk";
  version = "2.14.0";

  src = fetchurl {
    url = "https://github.com/mtgto/macSKK/releases/download/${finalAttrs.version}/macSKK-${finalAttrs.version}.dmg";
    hash = "sha256-fjvrH/sd6A0d4ye7L/YMb+j4G6yxIZkxY4CN6z/n5JE=";
  };

  nativeBuildInputs = [
    _7zz
    cpio
    xar
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isAarch64 [ darwin.autoSignDarwinBinariesHook ];

  unpackPhase = ''
    runHook preUnpack

    7zz x $src
    xar -xf macSKK-${finalAttrs.version}.pkg
    cat app.pkg/Payload | gunzip -dc | cpio -i

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/Library/Input\ Methods
    mkdir -p "$out/bin"
    cp -a "Library/Input Methods/macSKK.app" "$out/Library/Input Methods/"
    ln -s "$out/Library/Input Methods/macSKK.app/Contents/MacOS/macSKK" "$out/bin/macSKK"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

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
