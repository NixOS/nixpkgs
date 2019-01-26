{ stdenv, fetchurl, glib, gtk2, pkgconfig, hamlib }:
stdenv.mkDerivation rec {
  name = "xlog-${version}";
  version = "2.0.15";
  
  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/xlog/${name}.tar.gz";
    sha256 = "0an883wqw3zwpw8nqinm9cb17hp2xw9vf603k4l2345p61jqdw2j";
  };

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
    homepage = https://www.nongnu.org/xlog;
    maintainers = [ maintainers.mafo ];
    license = licenses.gpl3;
    platforms = platforms.unix;
  };

}
