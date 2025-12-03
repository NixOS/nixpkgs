{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:
stdenv.mkDerivation rec {
  pname = "mlc";
  version = "3.12";

  src = fetchurl {
    url = "https://downloadmirror.intel.com/866182/mlc_v${version}.tgz";
    hash = "sha256-S492hdcZmN1dRFQyq0DCEVFYRiv801kROuVRqE4lDFA=";
  };

  sourceRoot = "Linux";

  installPhase = ''
    install -Dm755 mlc $out/bin/mlc
  '';

  nativeBuildInputs = [ autoPatchelfHook ];


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
