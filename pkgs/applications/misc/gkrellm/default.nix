args: with args;

stdenv.mkDerivation {
  name = "gkrellm-2.3.1";
  src = fetchurl {
    url = http://members.dslextreme.com/users/billw/gkrellm/gkrellm-2.3.1.tar.bz2;
    sha256 = "1a2a7e3ee9d1f2d7305da0d33d9be71ffe5d1903ed6a9c69cf77ffe10fc95b4d";
  };

  buildInputs = [gettext pkgconfig glib gtk libX11 libSM libICE];

  # Makefiles are patched to fix references to `/usr/X11R6' and to add
  # `-lX11' to make sure libX11's store path is in the RPATH.
  patchPhase = ''
     echo "patching makefiles..."
     for i in Makefile src/Makefile server/Makefile
     do
       cat "$i" | sed -e "s|/usr/X11R6|${libX11}|g ;
                          s|-lICE|-lX11 -lICE|g" > ",,tmp" &&	\
       mv ",,tmp" "$i"
     done '';

  buildPhase = ''
     make PREFIX="$out" '';
  installPhase = ''
     make install PREFIX="$out" '';

  meta = {
    description = "GKrellM, a themeable process stack of system monitors.";
    homepage = http://members.dslextreme.com/users/billw/gkrellm/gkrellm.html;
    license = "GPL";
  };
}
