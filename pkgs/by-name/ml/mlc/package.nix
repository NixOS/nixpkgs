{
  lib,
  stdenv,
  fetchurl,
  patchelf,
}:
stdenv.mkDerivation (prevAttrs: {
  pname = "mlc";
  version = "3.11b";

  src = fetchurl {
    url = "https://downloadmirror.intel.com/834254/mlc_v${prevAttrs.version}.tgz";
    sha256 = "sha256-XVq9J9FFr1nVZMnFOTgwGgggXwdbm9QfL5K0yO/rKCQ=";
  };

  sourceRoot = "Linux";

  installPhase = ''
    install -Dm755 mlc $out/bin/mlc
  '';

  nativeBuildInputs = [ patchelf ];

  fixupPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/mlc
  '';

  meta = with lib; {
    homepage = "https://software.intel.com/content/www/us/en/develop/articles/intelr-memory-latency-checker.html";
    description = "Intel Memory Latency Checker";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ basvandijk ];
    platforms = with platforms; linux;
    mainProgram = "mlc";
  };
})
