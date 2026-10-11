{
  lib,
  stdenv,
  patchelf,
  requireFile,
}:
stdenv.mkDerivation rec {
  pname = "mlc";
  version = "3.12";

  src = requireFile {
    url = "https://www.intel.com/content/www/us/en/download/736633/intel-memory-latency-checker-intel-mlc.html";
    sha256 = "4b8f7685d71998dd5d445432ab40c2115158462bfcd359113ae551a84e250c50";
    name = "mlc_v${version}.tgz";
  };

  sourceRoot = "Linux";

  installPhase = ''
    install -Dm755 mlc $out/bin/mlc
  '';

  nativeBuildInputs = [ patchelf ];

  fixupPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/mlc
  '';

  meta = {
    homepage = "https://software.intel.com/content/www/us/en/develop/articles/intelr-memory-latency-checker.html";
    description = "Intel Memory Latency Checker";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ basvandijk ];
    platforms = with lib.platforms; linux;
    mainProgram = "mlc";
  };
}
