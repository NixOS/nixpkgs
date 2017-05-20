{ fetchurl, stdenv, gettext, pkgconfig, glib, gtk2, libX11, libSM, libICE
, IOKit ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gkrellm-2.3.10";

  src = fetchurl {
    url = "http://gkrellm.srcbox.net/releases/${name}.tar.bz2";
    sha256 = "0rnpzjr0ys0ypm078y63q4aplcgdr5nshjzhmz330n6dmnxci7lb";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [gettext glib gtk2 libX11 libSM libICE]
    ++ optionals stdenv.isDarwin [ IOKit ];

  hardeningDisable = [ "format" ];

  # Makefiles are patched to fix references to `/usr/X11R6' and to add
  # `-lX11' to make sure libX11's store path is in the RPATH.
  patchPhase = ''
     echo "patching makefiles..."
     for i in Makefile src/Makefile server/Makefile
     do
       sed -i "$i" -e "s|/usr/X11R6|${libX11.dev}|g ; s|-lICE|-lX11 -lICE|g"
     done '';

   installPhase = ''
     make DESTDIR=$out install
     '';

   meta = {
    description = "Themeable process stack of system monitors";
    longDescription =
      '' GKrellM is a single process stack of system monitors which supports
         applying themes to match its appearance to your window manager, Gtk,
         or any other theme.
      '';

    homepage = http://gkrellm.srcbox.net;
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
