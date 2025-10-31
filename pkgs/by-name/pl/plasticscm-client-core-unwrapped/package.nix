{
  dpkg,
  fetchurl,
  lib,
  makeWrapper,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plasticscm-client-core-unwrapped";
  version = "11.0.16.9656";

  src = fetchurl {
    url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-client-core_${finalAttrs.version}_amd64.deb";
    hash = "sha256-4ywIltUBg050pm7h67ZabvBOrCsOpt8KjlcHJqsLLjQ=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
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
    mainProgram = "cm";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ musjj ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
