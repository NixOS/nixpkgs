{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alcove";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/henrikruscon/alcove-releases/releases/download/${finalAttrs.version}/Alcove.zip";
    hash = "sha256-MhwtQDuDKP4vLPvOxSe9pY2W//dHplHlu6YvxfswNOg=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R ./Alcove.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dynamic Island for your Mac";
    homepage = "https://tryalcove.com/";
    changelog = "https://github.com/henrikruscon/alcove-releases/releases/tag/${finalAttrs.version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ delafthi ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
