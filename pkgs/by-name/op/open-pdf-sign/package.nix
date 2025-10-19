{
  fetchurl,
  jre,
  lib,
  makeBinaryWrapper,
  nix-update-script,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.3.0";
  pname = "open-pdf-sign";

  src = fetchurl {
    url = "https://github.com/open-pdf-sign/open-pdf-sign/releases/download/v${finalAttrs.version}/open-pdf-sign.jar";
    hash = "sha256-tGTWKw/xLhC1B+uogTUmWHUtHNNdE3BLuxToWvrduXs=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  buildCommand = ''
    install -Dm644 $src $out/lib/open-pdf-sign.jar

    mkdir -p $out/bin
    makeWrapper ${lib.getExe jre} $out/bin/open-pdf-sign \
      --add-flags "-jar $out/lib/open-pdf-sign.jar"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Digitally sign PDF files from your commandline";
    homepage = "https://github.com/open-pdf-sign/open-pdf-sign";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    mainProgram = "open-pdf-sign";
  };
})
