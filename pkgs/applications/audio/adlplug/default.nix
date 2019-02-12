{ stdenv, fetchFromGitHub, cmake, pkgconfig, libjack2, alsaLib
, freetype, libX11, libXrandr, libXinerama, libXext, libXcursor
, adlplugChip ? "-DADLplug_CHIP=OPL3"
, pname ? "ADLplug" }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "v1.0.0-beta.5";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = "ADLplug";
    rev = version;
    sha256 = "1f8v61nv33xwpzmmk38dkr3fvm2j2xf0a74agxnl9p1yvy3a9w3s";
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
