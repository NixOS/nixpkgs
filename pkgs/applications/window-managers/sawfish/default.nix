{ lib
, stdenv
, fetchurl
, autoreconfHook
, gdk-pixbuf-xlib
, gettext
, gtk2
, libICE
, libSM
, libxcrypt
, libXinerama
, libXrandr
, libXtst
, librep
, makeWrapper
, pango
, pkg-config
, rep-gtk
, texinfo
, which
}:

stdenv.mkDerivation rec {
  pname = "sawfish";
  version = "1.13.0";

  src = fetchurl {
    url = "https://download.tuxfamily.org/sawfish/${pname}_${version}.tar.xz";
    sha256 = "sha256-gWs8W/pMtQjbH8FEifzNAj3siZzxPd6xm8PmXXhyr10=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    librep
    makeWrapper
    pkg-config
    texinfo
    which
  ];
  buildInputs = [
    gdk-pixbuf-xlib
    gtk2
    libICE
    libSM
    libxcrypt
    libXinerama
    libXrandr
    libXtst
    librep
    pango
    rep-gtk
  ];

  postPatch = ''
    sed -e 's|REP_DL_LOAD_PATH=|REP_DL_LOAD_PATH=$(REP_DL_LOAD_PATH):|g' -i Makedefs.in
    sed -e 's|$(repexecdir)|$(libdir)/rep|g' -i src/Makefile.in
  '';

  strictDeps = true;

  postInstall = ''
    for i in $out/lib/sawfish/sawfish-menu \
             $out/bin/sawfish-about \
             $out/bin/sawfish-client \
             $out/bin/sawfish-config \
             $out/bin/sawfish; do
      wrapProgram $i \
        --prefix REP_DL_LOAD_PATH : "$out/lib/rep" \
        --set REP_LOAD_PATH "$out/share/sawfish/lisp"
    done
  '';

  meta = with lib; {
    homepage = "http://sawfish.tuxfamily.org/";
    description = "An extensible, Lisp-based window manager";
    longDescription = ''
      Sawfish is an extensible window manager using a Lisp-based scripting
      language. Its policy is very minimal compared to most window managers. Its
      aim is simply to manage windows in the most flexible and attractive manner
      possible. All high-level WM functions are implemented in Lisp for future
      extensibility or redefinition.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
