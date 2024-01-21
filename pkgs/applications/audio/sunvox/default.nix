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
  version = "2.1.1c";

  src = fetchurl {
    urls = [
      "https://www.warmplace.ru/soft/sunvox/sunvox-${version}.zip"
      # Upstream removes downloads of older versions, please save bumped versions to archive.org
      "https://web.archive.org/web/20231204012052/https://www.warmplace.ru/soft/sunvox/sunvox-2.1.1c.zip"
    ];
    sha256 = "sha256-LfBQ/f2X75bcqLp39c2tdaSlDm+E73GUvB68XFqiicw=";
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
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    homepage = "http://www.warmplace.ru/soft/sunvox/";
    maintainers = with maintainers; [ puffnfresh ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
