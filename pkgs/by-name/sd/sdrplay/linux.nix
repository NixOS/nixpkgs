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
  binaryDirs = {
    "armv7l" = "armhf";
    "aarch64" = "arm64";
    "x86_64" = "amd64";
  };

  binDir =
    binaryDirs.${stdenv.hostPlatform.parsed.cpu.name}
      or (throw "Architecture ${stdenv.hostPlatform.parsed.cpu.name} not supported");

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
    mkdir -p $out/{bin,lib,include,lib/udev/rules.d}
    libName="libsdrplay_api"
    cp "${binDir}/$libName.so.$majorMinorVersion" $out/lib/
    ln -s "$out/lib/$libName.so.$majorMinorVersion" "$out/lib/$libName.so.$majorVersion"
    ln -s "$out/lib/$libName.so.$majorVersion" "$out/lib/$libName.so"
    cp "${binDir}/sdrplay_apiService" $out/bin/
    cp -r inc/* $out/include/
    awk 'index($0, "cat > /etc/udev/rules.d/66-sdrplay.rules"){flag=1; next} /EOF/{flag=0} flag' install_lib.sh > $out/lib/udev/rules.d/66-sdrplay.rules
  '';
}
