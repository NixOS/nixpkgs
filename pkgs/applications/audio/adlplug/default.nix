{ stdenv, fetchFromGitHub, cmake, pkgconfig, libjack2, alsaLib
, freetype, libX11, libXrandr, libXinerama, libXext, libXcursor
, adlplugChip ? "-DADLplug_CHIP=OPL3"
, pname ? "ADLplug" }:

stdenv.mkDerivation rec {
  inherit pname;
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = "ADLplug";
    rev = "v${version}";
    sha256 = "1rpd7v1rx74cv7nhs70ah0bly314rjzj70cp30mvhns2hzk66s3c";
    fetchSubmodules = true;
  };

  cmakeFlags = [ adlplugChip ];

  buildInputs = [
    libjack2 alsaLib freetype libX11 libXrandr libXinerama libXext
    libXcursor
  ];
  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "Synthesizer plugin for ADLMIDI and OPNMIDI (VST/LV2)";
    homepage = src.meta.homepage;
    license = licenses.boost;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}
