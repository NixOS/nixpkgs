{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "iravoice";
  version = "0.7.2";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://iravoice.com/downloads/distribution/IraVoice-${finalAttrs.version}.dmg";
    hash = "sha256-ZOT+T6mix1NgUwbe8O9uts0bbRL1MMk77MGvPcKSNN0=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R IraVoice.app "$out/Applications/"

    runHook postInstall
  '';

  meta = {
    description = "Private on-device dictation app for Apple-silicon Macs";
    homepage = "https://iravoice.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ iravoiceFounder ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
