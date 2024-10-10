{ lib
, stdenvNoCC
, fetchurl
, unzip
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "transmit";
  version = "5.9.2";

  src = fetchurl {
    url = "https://www.panic.com/transmit/d/Transmit%20${finalAttrs.version}.zip";
    sha256 = "17d2a1n1c1048ln86bv8h4jhk6qsi2jdsdqy628kzrk4pm8174px";
  };
  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    unzip -d $out/Applications $src

    runHook postInstall
  '';
  dontPatchShebangs = true;

  meta = with lib; {
    description = "macOS file transfer application";
    homepage = "https://panic.com/transmit";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = platforms.darwin;
  };
})
