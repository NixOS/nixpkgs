{
  lib,
  fetchurl,
  stdenvNoCC,
  _7zz,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "longbridge";
  version = "0.13.2";

  src =
    let
      arch = if stdenvNoCC.hostPlatform.isAarch64 then "aarch64" else "x86_64";
    in
    fetchurl {
      url = "https://assets.lbkrs.com/github/release/longbridge-desktop/stable/longbridge-v${finalAttrs.version}-macos-${arch}.dmg";
      hash =
        {
          aarch64 = "sha256-iXekciHi5yIngtC2g7h+eOXXyo6vxd+gGOUZ3M9v/PM=";
          x86_64 = "sha256-pWvrRFP9W3HeOwOMgCgzgZy/ddPw2l6lgsNPP3me1Fw=";
        }
        .${arch};
    };

  nativeBuildInputs = [ _7zz ];

  unpackPhase = ''
    runHook preUnpack
    7zz x -snld $src
    runHook postUnpack
  '';

  sourceRoot = "Longbridge.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Longbridge.app"
    cp -R . "$out/Applications/Longbridge.app"

    mkdir -p "$out/bin"
    ln -s "$out/Applications/Longbridge.app/Contents/MacOS/Longbridge" "$out/bin/longbridge"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Stock trading platform";
    homepage = "https://longbridge.com/";
    changelog = "https://longbridge.com/desktop/release-notes/v${finalAttrs.version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "longbridge";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
