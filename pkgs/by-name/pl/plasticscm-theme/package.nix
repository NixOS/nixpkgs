{
  dpkg,
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plasticscm-theme";
  version = "11.0.16.9478";

  src = fetchurl {
    url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-theme_${finalAttrs.version}_amd64.deb";
    hash = "sha256-HyA1HEpeW1m04zCTApjyheC2mxWr+y3ODUFOYjujLPU=";
  };

  nativeBuildInputs = [
    dpkg
  ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x $src .

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r opt usr/share $out

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.plasticscm.com";
    description = "A Software Configuration Management system from Unity that tracks changes to source code and any digital asset over time";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ musjj ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
