{ fetchurl, stdenv, gettext, pkgconfig, glib, gtk, libX11, libSM, libICE
, IOKit ? null }:

stdenv.mkDerivation rec {
  name = "gkrellm-2.3.5";
  src = fetchurl {
    url = "http://members.dslextreme.com/users/billw/gkrellm/${name}.tar.bz2";
    sha256 = "12rc6zaa7kb60b9744lbrlfkxxfniprm6x0mispv63h4kh75navh";
  };

  buildInputs = [gettext pkgconfig glib gtk libX11 libSM libICE]
    ++ stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  hardeningDisable = [ "format" ];

  # Makefiles are patched to fix references to `/usr/X11R6' and to add
  # `-lX11' to make sure libX11's store path is in the RPATH.
  patchPhase = ''
     echo "patching makefiles..."
     for i in Makefile src/Makefile server/Makefile
     do
       sed -i "$i" -e "s|/usr/X11R6|${libX11.dev}|g ; s|-lICE|-lX11 -lICE|g"
     done '';

  buildPhase = ''
     make PREFIX="$out" '';
  installPhase = ''
     make install PREFIX="$out" '';

  meta = {
    description = "Themeable process stack of system monitors";
    longDescription =
      '' GKrellM is a single process stack of system monitors which supports
         applying themes to match its appearance to your window manager, Gtk,
         or any other theme.
      '';

    homepage = http://members.dslextreme.com/users/billw/gkrellm/gkrellm.html;
    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
