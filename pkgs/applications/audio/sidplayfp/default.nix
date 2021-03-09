{ stdenv
, lib
, fetchurl
, pkg-config
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
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/sidplay-residfp/sidplayfp/${majorMinor version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-qPmb2RXlSYj8mDNyvb70CUoJz+psc7ddLG0zkh8mq2k=";
  };

  nativeBuildInputs = [ pkg-config ]
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
