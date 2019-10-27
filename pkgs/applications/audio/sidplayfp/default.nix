{ stdenv, fetchurl, pkgconfig, libsidplayfp }:

stdenv.mkDerivation rec {
  version = "1.4.4";
  pname = "sidplayfp";

  src = fetchurl {
    url = "mirror://sourceforge/sidplay-residfp/sidplayfp/1.4/${pname}-${version}.tar.gz";
    sha256 = "0arsrg3f0fsinal22qjmj3r6500bcbgqnx26fsz049ldl716kz1m";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libsidplayfp ];

  meta = with stdenv.lib; {
    description = "A SID player using libsidplayfp";
    homepage = https://sourceforge.net/projects/sidplay-residfp/;
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ dezgeg ];
    platforms = with platforms; linux;
  };
}
