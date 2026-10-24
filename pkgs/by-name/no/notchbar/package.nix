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
    hash = "sha256-Z/wFSqhL/QFRWbGlrSxJwLEZNtl+N7gcu7BkRgZ95MQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/NotchBar.app $out/bin
    cp -r . $out/Applications/NotchBar.app
    ln -s $out/Applications/NotchBar.app/Contents/MacOS/${finalAttrs.meta.mainProgram} $out/bin

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
