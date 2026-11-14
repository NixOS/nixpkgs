{
  lib,
  fetchurl,
  stdenvNoCC,
  _7zz,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "longbridge";
  version = "0.20.1";
  strictDeps = true;
  __structuredAttrs = true;

  src =
    let
      arch = if stdenvNoCC.hostPlatform.isAarch64 then "aarch64" else "x86_64";
    in
    fetchurl {
      url = "https://assets.lbkrs.com/github/release/longbridge-desktop/stable/longbridge-v${finalAttrs.version}-macos-${arch}.dmg";
      hash =
        {
          aarch64 = "sha256-Tkf7pPzrHu4cL5bYnFKYjnsQpOyW73US2KH2BpgbuRU=";
          x86_64 = "sha256-Qv3vvOl+/9xYCMVbTfIF07VvtE9E+1a5ZM+D0QTydKw=";
        }
        .${arch};
    };

  nativeBuildInputs = [ _7zz ];

  unpackPhase = ''
    runHook preUnpack
    7zz x -snld $src
    runHook postUnpack
  '';

  # The vendor DMG contains a top-level `Longbridge/` directory.
  sourceRoot = "Longbridge/Longbridge.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Longbridge.app"
    cp -R . "$out/Applications/Longbridge.app"
    # 7zz exposes HFS provenance streams as colon-named files; they are not
    # bundle resources and make Apple's sealed-resource verification fail.
    find "$out/Applications/Longbridge.app" -name '*:com.apple.provenance' -delete

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
