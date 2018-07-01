{ stdenv, fetchurl, pkgconfig, libsidplayfp }:

stdenv.mkDerivation rec {
  version = "1.4.3";
  name = "sidplayfp-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sidplay-residfp/sidplayfp/1.4/${name}.tar.gz";
    sha256 = "04gqhxs4w0riabp1svgcs6gsxdmbfmrs4kaqr5lifvxjvv03vzsn";
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
