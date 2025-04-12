{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cyberduck";
  version = "9.0.0.41777";

  src = fetchurl {
    url = "https://update.cyberduck.io/Cyberduck-${finalAttrs.version}.zip";
    hash = "sha256-oDTFkoX4uu+X5vLDHn+tGoNB/Pd9ncdFE8dGS6PT5wg=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r Cyberduck.app $out/Applications

    runHook postInstall
  '';

  meta = with lib; {
    description = "Libre file transfer client for Mac and Windows";
    homepage = "https://cyberduck.io";
    license = licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.darwin;
  };
})
