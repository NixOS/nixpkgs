{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "subler";
  version = "1.9.1";

  src = fetchurl {
    url = "https://github.com/SublerApp/Subler/releases/download/${finalAttrs.version}/Subler-${finalAttrs.version}.zip";
    hash = "sha256-tYFyBG2G2Am+1HdS+pyOKr9MoAEpaYmITad04CyWL3Y=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R ./Subler.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MP4 muxer and editor";
    homepage = "https://subler.org/";
    changelog = "https://github.com/SublerApp/Subler/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ delafthi ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
