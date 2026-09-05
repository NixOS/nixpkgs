{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mlc";
  version = "3.12";

  src = fetchurl {
    url = "https://downloadmirror.intel.com/866182/mlc_v${finalAttrs.version}.tgz";
    hash = "sha256-S492hdcZmN1dRFQyq0DCEVFYRiv801kROuVRqE4lDFA=";
  };

  sourceRoot = "Linux";

  installPhase = ''
    install -Dm755 mlc $out/bin/mlc
  '';

  nativeBuildInputs = [ autoPatchelfHook ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "${finalAttrs.meta.mainProgram} --help";
    version = "v${finalAttrs.version}";
  };

  meta = {
    homepage = "https://software.intel.com/content/www/us/en/develop/articles/intelr-memory-latency-checker.html";
    description = "Intel Memory Latency Checker";
    changelog = "${finalAttrs.meta.homepage}#ChangeLog";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      basvandijk
      rrbutani
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "mlc";
  };
})
