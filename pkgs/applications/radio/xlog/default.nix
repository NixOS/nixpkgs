{ stdenv, fetchurl, glib, gtk2, pkgconfig, hamlib }:
stdenv.mkDerivation rec {
  pname = "xlog";
  version = "2.0.19";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/xlog/${pname}-${version}.tar.gz";
    sha256 = "0y38gkcm4mgv6wn31pjq6d5bm22m63rpwa55qjmrlywrmw76rppy";
  };

  # glib-2.62 deprecations
  NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS";

  buildInputs = [ glib pkgconfig gtk2 hamlib ];

  meta = with stdenv.lib; {
    description = "An amateur radio logging program";
    longDescription =
      '' Xlog is an amateur radio logging program.
         It supports cabrillo, ADIF, trlog (format also used by tlf),
         and EDI (ARRL VHF/UHF contest format) and can import twlog, editest and OH1AA logbook files.
         Xlog is able to do DXCC lookups and will display country information, CQ and ITU zone,
         location in latitude and longitude and distance and heading in kilometers or miles,
         both for short and long path.
      '';
    homepage = "https://www.nongnu.org/xlog";
    maintainers = [ maintainers.mafo ];
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
