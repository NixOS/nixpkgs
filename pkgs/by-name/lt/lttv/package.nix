{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
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

  patches = [
    # fix build with gcc14:
    (fetchpatch {
      name = "lttv-c99-compatibility-fix.patch";
      url = "https://git.lttng.org/?p=lttv.git;a=patch;h=6b9d59fe4cc1dc943501ab6ede93856b2f06c3ce";
      hash = "sha256-zcLHBri0i10NGkgiZT6QRZbixffYvkzLaFBeC/ESF/U=";
    })
  ];

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
