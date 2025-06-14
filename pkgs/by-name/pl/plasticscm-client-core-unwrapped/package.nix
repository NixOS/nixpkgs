{
  dpkg,
  fetchurl,
  lib,
  makeWrapper,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plasticscm-client-core-unwrapped";
  version = "11.0.16.9478";

  src = fetchurl {
    url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-client-core_${finalAttrs.version}_amd64.deb";
    hash = "sha256-Ls28r25lHBdZr3sR6qhkgfgP8270omAUxK0IIJb6By0=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
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
    cp -r opt usr/{share,bin} $out

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.plasticscm.com";
    description = "A Software Configuration Management system from Unity that tracks changes to source code and any digital asset over time";
    platforms = [ "x86_64-linux" ];
    mainProgram = "cm";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ musjj ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
