{ lib
, stdenvNoCC
, fetchurl
, unzip
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "forklift";
  version = "3.5.8";

  src = fetchurl {
    url = "https://download.binarynights.com/ForkLift${finalAttrs.version}.zip";
    sha256 = "01sjrhslvyjyljnqxgd855w8q1c03hxggkh101q6xss5h0mllz0d";
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
    description = "Dual pane file manager and file transfer client for macOS";
    homepage = "https://binarynights.com";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = platforms.darwin;
  };
})
