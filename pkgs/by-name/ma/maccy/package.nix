{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "maccy";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/p0deje/Maccy/releases/download/${finalAttrs.version}/Maccy.app.zip";
    hash = "sha256-Prr0t3OvPWUnUQ3cTE3D+jj1ASKKmDvGZInKlT1WsJ0=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    unzip -d $out/Applications $src

    runHook postInstall
  '';

  meta = with lib; {
    description = "Simple clipboard manager for macOS";
    homepage = "https://maccy.app";
    license = licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [
      emilytrau
      baongoc124
    ];
    platforms = platforms.darwin;
  };
})
