{ lib
, stdenvNoCC
, fetchurl
, unzip
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sim-daltonism";
  version = "2.0.5";

  src = fetchurl {
    url = "https://littoral.michelf.ca/apps/sim-daltonism/sim-daltonism-${finalAttrs.version}.zip";
    sha256 = "0wnsnv65y25imkffmcfk8rwld2a7dcg4zwqa9afb5ffpph7sm57h";
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
    description = "Color blindness simulator for Mac";
    homepage = "https://michelf.ca/projects/mac/sim-daltonism";
    license = licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = [ "x86_64-darwin" ];
  };
})
