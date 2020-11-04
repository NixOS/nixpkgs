{ stdenv
, lib
, fetchurl
, pkgconfig
, libsidplayfp
, alsaSupport ? stdenv.hostPlatform.isLinux
, alsaLib
, pulseSupport ? stdenv.hostPlatform.isLinux
, libpulseaudio
}:

assert alsaSupport -> alsaLib != null;
assert pulseSupport -> libpulseaudio != null;
let
  inherit (lib) optional;
  inherit (lib.versions) majorMinor;
in
stdenv.mkDerivation rec {
  pname = "sidplayfp";
  version = "2.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/sidplay-residfp/sidplayfp/${majorMinor version}/${pname}-${version}.tar.gz";
    sha256 = "1s2dfs9z1hwarpfzawg11wax9nh0zcqx4cafwq7iysckyg4scz4k";
  };

  nativeBuildInputs = [ pkgconfig ]
    ++ optional alsaSupport alsaLib
    ++ optional pulseSupport libpulseaudio;

  buildInputs = [ libsidplayfp ];

  meta = with lib; {
    description = "A SID player using libsidplayfp";
    homepage = "https://sourceforge.net/projects/sidplay-residfp/";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ dezgeg ];
    platforms = with platforms; linux;
  };
}
