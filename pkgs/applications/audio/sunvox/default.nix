{ lib, stdenv, fetchurl, unzip, alsa-lib, libX11, libXi, SDL2 }:

let
  libPath = lib.makeLibraryPath [ stdenv.cc.cc alsa-lib libX11 libXi SDL2 ];
  arch =
    if stdenv.isAarch64
    then "arm64"
    else if stdenv.isAarch32
    then "arm_armhf_raspberry_pi"
    else if stdenv.is64bit
    then "x86_64"
    else "x86";
in
stdenv.mkDerivation rec {
  pname = "SunVox";
  version = "2.0c";

  src = fetchurl {
    url = "http://www.warmplace.ru/soft/sunvox/sunvox-${version}.zip";
    sha256 = "949e5348da9faa92ce17aac943b58027bdb797b65c7f5f365ef0610bb6dd8a3d";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = "unzip $src";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share $out/bin
    mv sunvox $out/share/

    bin="$out/share/sunvox/sunvox/linux_${arch}/sunvox"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             --set-rpath "${libPath}" \
             "$bin"

    ln -s "$bin" $out/bin/sunvox
  '';

  meta = with lib; {
    description = "Small, fast and powerful modular synthesizer with pattern-based sequencer";
    license = licenses.unfreeRedistributable;
    homepage = "http://www.warmplace.ru/soft/sunvox/";
    maintainers = with maintainers; [ puffnfresh ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
