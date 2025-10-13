{
  pname,
  version,
  src,
  meta,
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  udev,
  libusb1,
}:
let
  arch = stdenv.hostPlatform.qemuArch;
in
stdenv.mkDerivation rec {
  inherit
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    libusb1
    udev
    (lib.getLib stdenv.cc.cc)
  ];

  unpackPhase = ''
    sh "$src" --noexec --target source
  '';

  sourceRoot = "source";

  dontBuild = true;

  env = {
    majorVersion = lib.versions.major version;
    majorMinorVersion = lib.versions.majorMinor version;
  };

  installPhase = ''
    mkdir -p $out/{bin,lib,include}
    libName="libsdrplay_api"
    cp "${arch}/$libName.so.$majorMinorVersion" $out/lib/
    ln -s "$out/lib/$libName.so.$majorMinorVersion" "$out/lib/$libName.so.$majorVersion"
    ln -s "$out/lib/$libName.so.$majorVersion" "$out/lib/$libName.so"
    cp "${arch}/sdrplay_apiService" $out/bin/
    cp -r inc/* $out/include/
  '';
}
