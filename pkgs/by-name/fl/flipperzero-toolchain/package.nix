{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libgcc,
  libnsl,
  libxcrypt,
}:

stdenv.mkDerivation rec {
  pname = "flipperzero-toolchain";
  version = "39";

  src = fetchurl {
    url = "https://update.flipperzero.one/builds/toolchain/gcc-arm-none-eabi-12.3-x86_64-linux-flipper-${version}.tar.gz";
    hash = "sha256-wETFkjP2b278+FSv/i1eCdutBNaHCdUTvHYLHZiJWFM=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    libgcc
    stdenv.cc.cc.lib # for libstdc++.so.6
    libnsl
    libxcrypt
  ];

  sourceRoot = ".";

  shellHook = ''
    export FBT_TOOLCHAIN_PATH=$out/opt/flipperzero-toolchain
  '';

  installPhase = ''
    mkdir -p $out/opt/flipperzero-toolchain/toolchain/x86_64-linux
    cp -r gcc-arm-none-eabi-12.3-x86_64-linux-flipper/* $out/opt/flipperzero-toolchain/toolchain/x86_64-linux
    ln -sf ${libnsl}/lib/libnsl.so.3 $out/opt/flipperzero-toolchain/toolchain/x86_64-linux/lib/libnsl.so.2
    ln -sf ${libxcrypt}/lib/libcrypt.so.2 $out/opt/flipperzero-toolchain/toolchain/x86_64-linux/lib/libcrypt.so.1
    ln -sf $out/opt/flipperzero-toolchain/toolchain/x86_64-linux $out/opt/flipperzero-toolchain/toolchain/current
  '';

  meta = {
    description = "Toolchain for the flipperzero";
    homepage = "https://github.com/flipperdevices/flipperzero-toolchain";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ CodeRadu ];
    platforms = lib.platforms.linux;
  };
}
