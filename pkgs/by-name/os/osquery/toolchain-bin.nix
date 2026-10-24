{
  stdenv,
  lib,
  fetchzip,
  autoPatchelfHook,
}:
let

  version = "1.2.0";

  dist = {
    "x86_64-linux" = {
      url = "https://github.com/osquery/osquery-toolchain/releases/download/${version}/osquery-toolchain-${version}-x86_64.tar.xz";
      hash = "sha256-nLwnNsXQ+J0ms75YJHVFT9xb6F3RFJScgFlvuZ4JiYE=";
    };
    "aarch64-linux" = {
      url = "https://github.com/osquery/osquery-toolchain/releases/download/${version}/osquery-toolchain-${version}-aarch64.tar.xz";
      hash = "sha256-Vt4LA6H/TsrwJgB03eqrP2WqHbRqwQq5RK4PtGiqsVc=";
    };
  };

in

stdenv.mkDerivation {

  name = "osquery-toolchain-bin";

  inherit version;

  src = fetchzip dist.${stdenv.hostPlatform.system};

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    mkdir $out
    cp -r * $out
  '';

  meta = {
    description = "LLVM-based toolchain for Linux designed to build a portable osquery";
    homepage = "https://github.com/osquery/osquery-toolchain";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; [
      gpl2Only
      asl20
    ];
    maintainers = [ ];
  };
}
