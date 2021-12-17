{ bzip2
, fetchurl
, glib
, gperf
, gtk3
, judy
, lib
, pkg-config
, stdenv
, tcl
, tk
, wrapGAppsHook
, xz
}:

stdenv.mkDerivation rec {
  pname = "gtkwave";
  version = "3.3.111";

  src = fetchurl {
    url = "mirror://sourceforge/gtkwave/${pname}-gtk3-${version}.tar.gz";
    sha256 = "0cv222qhgldfniz6zys52zhrynfsp5v0h8ia857lng7v33vw5qdl";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];
  buildInputs = [ bzip2 glib gperf gtk3 judy tcl tk xz ];

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
    "--enable-judy"
    "--enable-gtk3"
  ];

  meta = {
    description = "VCD/Waveform viewer for Unix and Win32";
    homepage = "http://gtkwave.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = lib.platforms.linux;
  };
}
