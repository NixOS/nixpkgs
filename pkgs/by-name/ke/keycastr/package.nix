{
  stdenvNoCC,
  lib,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "keycastr";
  version = "0.10.1";

  src = fetchurl {
    url = "https://github.com/keycastr/keycastr/releases/download/v${finalAttrs.version}/KeyCastr.app.zip";
    hash = "sha256-Ea/QtYiM7J2Gc5T8M+WizSBrgmhJ+NW4ern2A58glUk=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r KeyCastr.app $out/Applications/
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://github.com/keycastr/keycastr";
    description = "Open-source keystroke visualizer";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ matteopacini ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
