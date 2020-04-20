{ stdenv, fetchurl, unzip, alsaLib, libX11, libXi, SDL2 }:

let
  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.cc alsaLib libX11 libXi SDL2 ];
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
  version = "1.9.5d";

  src = fetchurl {
    url = "http://www.warmplace.ru/soft/sunvox/sunvox-${version}.zip";
    sha256 = "15pyc3dk4dqlivgzki8sv7xpwg3bbn5xv9338g16a0dbn7s3kich";
  };

  buildInputs = [ unzip ];

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

  meta = with stdenv.lib; {
    description = "Small, fast and powerful modular synthesizer with pattern-based sequencer";
    license = licenses.unfreeRedistributable;
    homepage = "http://www.warmplace.ru/soft/sunvox/";
    maintainers = with maintainers; [ puffnfresh ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
