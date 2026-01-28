{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "notchbar";
  version = "0.0.3.2";

  src = fetchzip {
    url = "https://github.com/navtoj/NotchBar/releases/download/${finalAttrs.version}/NotchBar.zip";
    sha256 = "sha256-Z/wFSqhL/QFRWbGlrSxJwLEZNtl+N7gcu7BkRgZ95MQ=";
  };

  installPhase = ''
    runHook preInstall

    mkdir --parent $out/Applications/NotchBar.app
    mv * "$_"
    install -D "$_/Contents/MacOS/${finalAttrs.meta.mainProgram}" \
      --target-directory=$out/bin

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utilize the empty space around the notch";
    homepage = "https://github.com/navtoj/NotchBar";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "NotchBar";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = lib.platforms.darwin;
  };
})
