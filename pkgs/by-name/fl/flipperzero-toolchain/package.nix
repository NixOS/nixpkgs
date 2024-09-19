{ lib, stdenv, fetchurl, autoPatchelfHook, libgcc, libnsl, libxcrypt }:

stdenv.mkDerivation rec {
  pname = "flipperzero-toolchain";
  version = "33";

  src = fetchurl {
    url = "https://update.flipperzero.one/builds/toolchain/gcc-arm-none-eabi-12.3-x86_64-linux-flipper-${version}.tar.gz";
    sha256 = "1w9b6d0jglldmgaajczpn8f2i8brpwfwlzgsddxnqb0pk5hhs0jr";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

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
    cp -L ${libnsl}/lib/libnsl.so.3 $out/opt/flipperzero-toolchain/toolchain/x86_64-linux/lib/libnsl.so.2
    cp -L ${libxcrypt}/lib/libcrypt.so.2 $out/opt/flipperzero-toolchain/toolchain/x86_64-linux/lib/libcrypt.so.1
    ln -sf $out/opt/flipperzero-toolchain/toolchain/x86_64-linux $out/opt/flipperzero-toolchain/toolchain/current
  '';

  meta = with lib; {
    description = "Toolchain for the flipperzero";
    homepage = "https://github.com/flipperdevices/flipperzero-toolchain";
    license = licenses.gpl3;
    maintainers = with maintainers; [ CodeRadu ];
    platforms = platforms.linux;
  };
}
