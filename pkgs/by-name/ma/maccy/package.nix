{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "maccy";
  version = "2.7.1";

  src = fetchurl {
    url = "https://github.com/p0deje/Maccy/releases/download/${finalAttrs.version}/Maccy.app.zip";
    hash = "sha256-84iu403gmgx1MWMTA3hdmTi++akhMOIc4QScj1aq0Hc=";
    meta.identifiers.purlParts = {
      type = "github";
      spec = "p0deje/Maccy@${finalAttrs.version}";
    };
  };

  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    unzip -d $out/Applications $src

    runHook postInstall
  '';

  meta = {
    description = "Simple clipboard manager for macOS";
    homepage = "https://maccy.app";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      emilytrau
      baongoc124
    ];
    platforms = lib.platforms.darwin;
  };
})
