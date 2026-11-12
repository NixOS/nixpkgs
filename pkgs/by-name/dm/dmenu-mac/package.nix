{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dmenu-mac";
  version = "0.8.0";

  __structuredAttrs = true;
  strictDeps = true;

  # Upstream builds with Xcode; install the signed and notarized release,
  # like maccy and aerospace do, so the app keeps its Developer ID signature.
  src = fetchurl {
    url = "https://github.com/oNaiPs/dmenu-mac/releases/download/${finalAttrs.version}/dmenu-mac.zip";
    hash = "sha256-6SIzisxQmjWIICb7Zva5RnnliM2Gf6TrVylCC2xZqLA=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;
  # Keep the Developer ID signature and notarization intact.
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications $out/bin
    cp -R dmenu-mac.app $out/Applications/
    ln -s $out/Applications/dmenu-mac.app/Contents/Resources/dmenu-mac $out/bin/dmenu-mac

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keyboard-only application launcher for macOS";
    homepage = "https://github.com/oNaiPs/dmenu-mac";
    changelog = "https://github.com/oNaiPs/dmenu-mac/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.onaips ];
    mainProgram = "dmenu-mac";
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
