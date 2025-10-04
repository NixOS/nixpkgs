{
  lib,
  stdenv,
  fetchurl,
  avahi,
  obs-studio-plugins,
}:

let
  versionJSON = lib.importJSON ./version.json;
  ndiPlatform =
    if stdenv.hostPlatform.isAarch64 then
      "aarch64-rpi4-linux-gnueabi"
    else if stdenv.hostPlatform.isAarch32 then
      "arm-rpi2-linux-gnueabihf"
    else if stdenv.hostPlatform.isx86_64 then
      "x86_64-linux-gnu"
    else
      throw "unsupported platform for NDI SDK";
in
stdenv.mkDerivation rec {
  pname = "ndi-6";
  version = versionJSON.version;
  majorVersion = lib.versions.major version;
  installerName = "Install_NDI_SDK_v${majorVersion}_Linux";

  src = fetchurl {
    url = "https://downloads.ndi.tv/SDK/NDI_SDK_Linux/${installerName}.tar.gz";
    hash = versionJSON.hash;
  };

  buildInputs = [ avahi ];

  unpackPhase = ''
    unpackFile $src
    echo y | ./${installerName}.sh
    sourceRoot="NDI SDK for Linux";
  '';

  installPhase = ''
    mkdir $out
    mv bin/${ndiPlatform} $out/bin
    for i in $out/bin/*; do
      if [ -L "$i" ]; then continue; fi
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$i"
    done
    patchelf --set-rpath "${avahi}/lib:${stdenv.cc.libc}/lib" $out/bin/ndi-record
    patchelf --set-rpath "${avahi}/lib:${stdenv.cc.libc}/lib" $out/bin/ndi-free-audio
    mv lib/${ndiPlatform} $out/lib
    for i in $out/lib/*; do
      if [ -L "$i" ]; then continue; fi
      patchelf --set-rpath "${avahi}/lib:${stdenv.cc.libc}/lib" "$i"
    done
    rm $out/bin/libndi.so.${majorVersion}
    ln -s $out/lib/libndi.so $out/bin/libndi.so.${majorVersion}
    # Fake ndi version 5 for compatibility with DistroAV (obs plugin using NDI)
    ln -s $out/lib/libndi.so $out/bin/libndi.so.5
    mv include examples $out/
    mkdir -p $out/share/doc/ndi-6
    mv licenses $out/share/doc/ndi-6/licenses
    mv documentation/* $out/share/doc/ndi-6/
  '';

  # Stripping breaks ndi-record.
  dontStrip = true;

  passthru.tests = {
    inherit (obs-studio-plugins) distroav;
  };

  passthru.updateScript = ./update.py;

  meta = {
    homepage = "https://ndi.video/ndi-sdk/";
    description = "NDI Software Developer Kit";
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
      "armv7l-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ globule655 ];
  };
}
