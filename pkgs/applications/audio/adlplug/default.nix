{ stdenv, fetchFromGitHub, cmake, pkgconfig, libjack2, alsaLib
, freetype, libX11, libXrandr, libXinerama, libXext, libXcursor
, fetchpatch
, adlplugChip ? "-DADLplug_CHIP=OPL3"
, pname ? "ADLplug" }:

stdenv.mkDerivation rec {
  inherit pname;
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = "ADLplug";
    rev = "v${version}";
    sha256 = "0n9srdlgl1j528ap5xmllrqs1w6ibc5yf9sphvl1q9kjnizxrs2c";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/jpcima/ADLplug/83636c55bec1b86cabf634b9a6d56d07f00ecc61/resources/patch/juce-gcc9.patch";
      sha256 = "15hkdb76n9lgjsrpczj27ld9b4804bzrgw89g95cj4sc8wwkplyy";
      extraPrefix = "thirdparty/JUCE/";
      stripLen = 1;
    })
  ];

  cmakeFlags = [ adlplugChip ];

  buildInputs = [
    libjack2 alsaLib freetype libX11 libXrandr libXinerama libXext
    libXcursor
  ];
  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "OPL3 and OPN2 FM Chip Synthesizer";
    homepage = src.meta.homepage;
    license = licenses.boost;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}
