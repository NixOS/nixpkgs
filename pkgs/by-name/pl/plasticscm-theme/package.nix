{
  dpkg,
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plasticscm-theme";
  version = "11.0.16.9656";

  src = fetchurl {
    url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-theme_${finalAttrs.version}_amd64.deb";
    hash = "sha256-GSZ2j/xZOUDI2SoqLWeGYq8YdPGLJ7ZXaJaOrsru8PY=";
  };

  nativeBuildInputs = [
    dpkg
  ];

  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r opt usr/share $out

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.plasticscm.com";
    description = "SCM by Unity for game development";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ musjj ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
