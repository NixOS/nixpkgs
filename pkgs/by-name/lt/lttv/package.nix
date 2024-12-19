{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  gtk2,
  popt,
  babeltrace,
}:

stdenv.mkDerivation rec {
  pname = "lttv";
  version = "1.5";

  src = fetchurl {
    url = "https://lttng.org/files/packages/${pname}-${version}.tar.bz2";
    sha256 = "1faldxnh9dld5k0vxckwpqw241ya1r2zv286l6rpgqr500zqw7r1";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    gtk2
    popt
    babeltrace
  ];

  meta = with lib; {
    description = "Graphical trace viewer for LTTng trace files";
    homepage = "https://lttng.org/";
    # liblttvtraceread (ltt/ directory) is distributed under the GNU LGPL v2.1.
    # The rest of the LTTV package is distributed under the GNU GPL v2.
    license = with licenses; [
      gpl2
      lgpl21
    ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
