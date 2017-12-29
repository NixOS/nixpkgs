{ stdenv, fetchurl
, pkgconfig, which, autoreconfHook
, rep-gtk, pango, gdk_pixbuf
, imlib, gettext, texinfo
, libXinerama, libXrandr, libXtst, libICE, libSM
, makeWrapper
}:

with stdenv.lib;

stdenv.mkDerivation rec {

  name = "sawfish-${version}";
  version = "1.12.0";
  sourceName = "sawfish_${version}";

  src = fetchurl {
    url = "http://download.tuxfamily.org/sawfish/${sourceName}.tar.xz";
    sha256 = "1z7awzgw8d15aw17kpbj460pcxq8l2rhkaxk47w7yg9qrmg0xja4";
  };

  buildInputs = [  pkgconfig which autoreconfHook
    rep-gtk pango gdk_pixbuf imlib gettext texinfo
    libXinerama libXrandr libXtst libICE libSM
    makeWrapper ];

  patchPhase = ''
    sed -e 's|REP_DL_LOAD_PATH=|REP_DL_LOAD_PATH=$(REP_DL_LOAD_PATH):|g' -i Makedefs.in
    sed -e 's|$(repexecdir)|$(libdir)/rep|g' -i src/Makefile.in
  '';

  postInstall = ''
    for i in $out/lib/sawfish/sawfish-menu $out/bin/sawfish-about  $out/bin/sawfish-client $out/bin/sawfish-config $out/bin/sawfish; do
      wrapProgram $i \
        --prefix REP_DL_LOAD_PATH : "$out/lib/rep" \
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
