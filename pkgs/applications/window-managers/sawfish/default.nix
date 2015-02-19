{ stdenv, fetchgit, pkgconfig, which, autoreconfHook, rep-gtk, pango, gdk_pixbuf, libXinerama, libXrandr, libXtst, imlib, gettext, texinfo, makeWrapper }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "sawfish-git-2015-02-15";

  src = fetchgit {
    url = "https://github.com/SawfishWM/sawfish.git";
    rev = "44729f44017e6779b4b66a7ecdbd63a98731f668";
    sha256 = "bd3f42f1604f37ecb2515008341cac4f6965840b2d6a6639dd1f3f2459f68e73";
  };

  buildInputs = [ pkgconfig which autoreconfHook rep-gtk pango gdk_pixbuf libXinerama libXrandr libXtst imlib gettext texinfo makeWrapper ];

  patchPhase = ''
    sed -e 's|REP_DL_LOAD_PATH=|REP_DL_LOAD_PATH=$(REP_DL_LOAD_PATH):|g' -i Makedefs.in
    sed -e 's|$(repexecdir)|$(libdir)/rep|g' -i src/Makefile.in
  '';

  postInstall = ''
    for i in $out/lib/sawfish/sawfish-menu $out/bin/sawfish-about  $out/bin/sawfish-client $out/bin/sawfish-config $out/bin/sawfish; do
      wrapProgram $i \
        --prefix REP_DL_LOAD_PATH "$out/lib/rep" \
	--set REP_LOAD_PATH "$out/share/sawfish/lisp"
    done
  '';
  
  meta = {
    description = "An extensible, Lisp-based window manager";
    longDescription = ''
      Sawfish is an extensible window manager using a Lisp-based scripting language.
      Its policy is very minimal compared to most window managers. Its aim is simply
      to manage windows in the most flexible and attractive manner possible.
      All high-level WM functions are implemented in Lisp for future extensibility
      or redefinition.
    '';
    homepage = http://sawfish.wikia.com;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
