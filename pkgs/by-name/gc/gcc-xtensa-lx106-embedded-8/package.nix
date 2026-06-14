{ lib, stdenv, fetchurl, }:

stdenv.mkDerivation rec {
  pname = "gcc-xtensa-lx106";
  version = "2020r3";

  suffix = {
    x86_64-linux = "linux-amd64";
    x86_64-darwin = "mac";
    i686-linux = "linux-i686";
  }.${stdenv.hostPlatform.system} or (throw
    "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url =
      "https://dl.espressif.com/dl/xtensa-lx106-elf-gcc8_4_0-esp-${version}-${suffix}.tar.gz";
    hash = {
      x86_64-linux = "sha256-ChgEteIjHG24tyr2vCoPmltplM+6KZVtQSZREJ8T/n4=";
      x86_64-darwin = "sha256-eCPF/fPOorWIzwxb2WJ3SrYKMLjZwZrgBWoO82l1N9s=";
      i686-linux = "sha256-yNzn6OtYwf304DunTrgJToA6C1uK1qnVcSFvYOtyyzY=";
    }.${stdenv.hostPlatform.system} or (throw
      "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    cp -r . $out
    find $out -type f | while read f; do
      patchelf "$f" > /dev/null 2>&1 || continue
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f" || true
      patchelf --set-rpath ${
        lib.makeLibraryPath [ "$out" stdenv.cc.cc ]
      } "$f" || true
    done
  '';

  meta = with lib; {
    description = "Pre-built GNU toolchain for ESP8266 processors";
    homepage =
      "https://docs.espressif.com/projects/esp8266-rtos-sdk/en/latest/get-started/linux-setup.html";
    license = with licenses; [ bsd2 gpl2 gpl3 lgpl21 lgpl3 mit ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "i686-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
