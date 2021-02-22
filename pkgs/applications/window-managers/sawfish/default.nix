{ lib, stdenv
, fetchurl
, pkg-config
, which
, autoreconfHook
, rep-gtk
, pango
, gdk-pixbuf-xlib
, imlib
, gettext
, texinfo
, libXinerama
, libXrandr
, libXtst
, libICE
, libSM
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "sawfish";
  version = "1.12.90";

  src = fetchurl {
    url = "https://download.tuxfamily.org/sawfish/${pname}_${version}.tar.xz";
    sha256 = "18p8srqqj9vjffg13qhspfz2gr1h4vfs10qzlv89g76r289iam31";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ which
    rep-gtk pango gdk-pixbuf-xlib imlib gettext texinfo
    libXinerama libXrandr libXtst libICE libSM
    makeWrapper ];

  patchPhase = ''
    sed -e 's|REP_DL_LOAD_PATH=|REP_DL_LOAD_PATH=$(REP_DL_LOAD_PATH):|g' -i Makedefs.in
    sed -e 's|$(repexecdir)|$(libdir)/rep|g' -i src/Makefile.in
  '';

  postInstall = ''
    for i in $out/lib/sawfish/sawfish-menu $out/bin/sawfish-about \
             $out/bin/sawfish-client $out/bin/sawfish-config $out/bin/sawfish; do
      wrapProgram $i \
        --prefix REP_DL_LOAD_PATH : "$out/lib/rep" \
        --set REP_LOAD_PATH "$out/share/sawfish/lisp"
    done
  '';

  meta = with lib; {
    description = "An extensible, Lisp-based window manager";
    longDescription = ''
      Sawfish is an extensible window manager using a Lisp-based scripting language.
      Its policy is very minimal compared to most window managers. Its aim is simply
      to manage windows in the most flexible and attractive manner possible.
      All high-level WM functions are implemented in Lisp for future extensibility
      or redefinition.
    '';
    homepage = "https://sawfish.fandom.com/wiki/Main_Page";
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
