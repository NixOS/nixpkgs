{
  stdenv,
  lib,
  fetchzip,
  autoPatchelfHook,
}:
let

  version = "1.1.0";

  dist = {
    "x86_64-linux" = {
      url = "https://github.com/osquery/osquery-toolchain/releases/download/${version}/osquery-toolchain-${version}-x86_64.tar.xz";
      hash = "sha256-irekR8a0d+T64+ZObgblsLoc4kVBmb6Gv0Qf8dLDCMk=";
    };
    "aarch64-linux" = {
      url = "https://github.com/osquery/osquery-toolchain/releases/download/${version}/osquery-toolchain-${version}-aarch64.tar.xz";
      hash = "sha256-cQlx9AtO6ggIQqHowa+42wQ4YCMCN4Gb+0qqVl2JElw=";
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

  meta = with lib; {
    description = "A LLVM-based toolchain for Linux designed to build a portable osquery";
    homepage = "https://github.com/osquery/osquery-toolchain";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = with licenses; [
      gpl2Only
      asl20
    ];
    maintainers = with maintainers; [ squalus ];
  };
}
