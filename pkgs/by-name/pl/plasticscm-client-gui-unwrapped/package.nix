{
  dpkg,
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plasticscm-client-gui-unwrapped";
  version = "11.0.16.9656";

  src = fetchurl {
    url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-client-gui_${finalAttrs.version}_amd64.deb";
    hash = "sha256-H+9vi9Yfz3uVA/dUwpMmrPOfGt0elAJ+jeFs2usp5L0=";
  };

  nativeBuildInputs = [
    dpkg
  ];

  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r opt usr/{share,bin} $out

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.plasticscm.com";
    description = "SCM by Unity for game development";
    platforms = [ "x86_64-linux" ];
    mainProgram = "plasticgui";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ musjj ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
