{
  lib,
  stdenv,
  fetchurl,
  avahi,
  ffmpeg_4,
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
    else if stdenv.hostPlatform.isi686 then
      "i686-linux-gnu"
    else
      throw "unsupported platform for NDI SDK";
in
stdenv.mkDerivation rec {
  pname = "ndi";
  version = versionJSON.version;
  majorVersion = builtins.head (builtins.splitVersion version);
  installerName = "Install_NDI_SDK_v${majorVersion}_Linux";

  src = fetchurl {
    name = "${pname}-${version}.tar.gz";
    url = "https://downloads.ndi.tv/SDK/NDI_SDK_Linux/${installerName}.tar.gz";
    hash = versionJSON.hash;
  };

  unpackPhase = ''
    unpackFile $src
    echo y | ./${installerName}.sh
    sourceRoot="NDI SDK for Linux";
  '';

  installPhase = ''
    mkdir -p $out $out/share/doc/${pname}-${version}
    mv bin/${ndiPlatform} $out/bin
    mv lib/${ndiPlatform} $out/lib
    mv include examples $out/
    mv licenses $out/share/doc/${pname}-${version}/licenses
    mv documentation/* $out/share/doc/${pname}-${version}/
  '';

  dontPatchELF = true;

  fixupPhase = ''
    for i in $out/bin/*; do
      if [ -L "$i" ]; then continue; fi
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$i"
      patchelf --set-rpath "${avahi}/lib:${ffmpeg_4.lib}/lib:${stdenv.cc.libc}/lib" "$i"
    done
    for i in $out/lib/*; do
      if [ -L "$i" ]; then continue; fi
      patchelf --set-rpath "${avahi}/lib:${ffmpeg_4.lib}/lib:${stdenv.cc.libc}/lib" "$i"
    done
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
    maintainers = with maintainers; [ ChaosAttractor ];
    hydraPlatforms = [ ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
  };
}
