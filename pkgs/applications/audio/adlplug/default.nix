{ stdenv, fetchFromGitHub, cmake, pkgconfig, libjack2, alsaLib
, freetype, libX11, libXrandr, libXinerama, libXext, libXcursor
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
