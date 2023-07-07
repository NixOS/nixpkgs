{ lib
, stdenvNoCC
, fetchurl
, unzip
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kaleidoscope";
  version = "4.0.5-3923";

  src = fetchurl {
    url = "https://updates.kaleidoscope.app/v${lib.versions.major finalAttrs.version}/prod/Kaleidoscope-${finalAttrs.version}.app.zip";
    sha256 = "066p3ifxgn7kckc3qgbbj7mpdsacb5mi70vd68avdypn9wvrm3jd";
  };
  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications $out/bin
    unzip -d $out/Applications $src
    ln -s ../Applications/Kaleidoscope.app/Contents/MacOS/ksdiff $out/bin/ksdiff

    runHook postInstall
  '';
  dontPatchShebangs = true;

  meta = with lib; {
    description = "Spot and merge differences in text and image files or folders";
    homepage = "https://kaleidoscope.app";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = platforms.darwin;
  };
})
