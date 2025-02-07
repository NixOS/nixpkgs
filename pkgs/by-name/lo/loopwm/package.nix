{
  stdenvNoCC,
  lib,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "loopwm";
  version = "1.1.1";

  src = fetchurl {
    url = "https://github.com/MrKai77/Loop/releases/download/${finalAttrs.version}/Loop.zip";
    hash = "sha256-eF8B4rmkyTtT0vWTcjdaNaWCHWSlPfS4uVV29L+wXiM=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r Loop.app $out/Applications
    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "macOS Window management made elegant";
    homepage = "https://github.com/MrKai77/Loop";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ matteopacini ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
