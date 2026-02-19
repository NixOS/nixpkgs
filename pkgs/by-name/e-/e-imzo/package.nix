{
  lib,
  stdenvNoCC,
  fetchurl,
  jre8,
  pcsclite,
  udev,
  makeWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "e-imzo";
  version = "5.00";

  src = fetchurl {
    url = "https://cdn.xinux.uz/e-imzo/E-IMZO-v${finalAttrs.version}.tar.gz";
    hash = "sha256-jPAZu98prkC4NQlfA8/kJuw9qdCrSSSyzySSWPlIXpY=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/e-imzo
    install -m 755 -d $out/lib/e-imzo
    install -m 644 ./E-IMZO.jar $out/lib/e-imzo/
    install -m 644 ./E-IMZO.pem $out/lib/e-imzo/
    install -m 644 ./truststore.jks $out/lib/e-imzo/
    cp -r ./lib $out/lib/e-imzo/

    makeWrapper ${jre8}/bin/java $out/bin/e-imzo \
      --set LD_LIBRARY_PATH "${
        lib.makeLibraryPath [
          udev
          pcsclite
        ]
      }" \
      --add-flags "-Dsun.security.smartcardio.library=${pcsclite.lib}/lib/libpcsclite${stdenvNoCC.hostPlatform.extensions.sharedLibrary}" \
      --add-flags "-jar $out/lib/e-imzo/E-IMZO.jar"

    runHook postInstall
  '';

  meta = {
    description = "For uzbek state web identity proving & key signing";
    mainProgram = "e-imzo";
    platforms = with lib.platforms; linux ++ darwin;
    homepage = "https://e-imzo.soliq.uz";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [
      orzklv
      shakhzodkudratov
      bahrom04
      bemeritus
    ];
  };
})
