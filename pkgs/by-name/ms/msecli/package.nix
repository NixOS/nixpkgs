{
  autoPatchelfHook,
  buildFHSEnv,
  fetchurl,
  lib,
  stdenv,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "msecli";
  version = "10.01.012024.00";

  src = fetchurl {
    url = "https://www.micron.com/content/dam/micron/global/public/products/software/storage-executive-software/msecli/msecli-linux.run";
    hash = "sha256-IszdD/9fAh+JA26bSR1roXSo8LDU/rf4CuRI3HjU1xc=";
  };

  buildInputs = [ zlib ];

  nativeBuildInputs = [ autoPatchelfHook ];

  unpackEnv = buildFHSEnv { name = "${pname}-unpackEnv"; };

  unpackPhase = ''
    cp "$src" ${src.name}
    chmod +x ${src.name}
    # ignore the exit code as the installer
    # fails at optional steps due to read only FHS
    ${unpackEnv}/bin/${unpackEnv.name} -c "./${src.name} --mode unattended --prefix bin || true"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -v bin/msecli $out/bin
  '';

  meta = {
    description = "Micron Storage Executive CLI";
    homepage = "https://www.micron.com/sales-support/downloads/software-drivers/storage-executive-software";
    license = lib.licenses.unfree;
    mainProgram = "msecli";
    maintainers = with lib.maintainers; [ diadatp ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
