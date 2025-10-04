{
  pname,
  version,
  src,
  meta,
  lib,
  stdenv,
  xar,
  cpio,
  libusb1,
  fixDarwinDylibNames,
}:
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [
    xar
    cpio
    fixDarwinDylibNames
  ];

  unpackPhase = ''
    xar -xf $src
    zcat SDRplayAPI.pkg/Payload | cpio -i
  '';

  dontBuild = true;

  env = {
    majorVersion = lib.versions.major version;
    majorMinorVersion = lib.versions.majorMinor version;
  };

  installPhase = ''
    root="$PWD/Library/SDRplayAPI/${version}"

    mkdir -p $out/{bin,lib}

    cp "$root/bin/sdrplay_apiService" "$out/bin"
    cp -r "$root/include" "$out/include"

    lib="$out/lib/libsdrplay_api.$majorMinorVersion.dylib"
    cp "$root/lib/libsdrplay_api.so.$majorMinorVersion" "$lib"
    ln -s "$lib" "$out/lib/libsdrplay_api.$majorVersion.dylib"
    ln -s "$lib" "$out/lib/libsdrplay_api.dylib"
  '';

  postFixup = ''
    install_name_tool -add_rpath "${lib.getLib libusb1}/lib" $out/bin/sdrplay_apiService
  '';
}
