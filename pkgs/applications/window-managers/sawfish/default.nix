{ lib
, stdenv
, fetchurl
, autoreconfHook
, gdk-pixbuf-xlib
, gettext
<<<<<<< HEAD
, gtk2-x11
=======
, gtk2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "sawfish";
  version = "1.13.0";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://download.tuxfamily.org/sawfish/sawfish_${finalAttrs.version}.tar.xz";
    hash = "sha256-gWs8W/pMtQjbH8FEifzNAj3siZzxPd6xm8PmXXhyr10=";
=======
    url = "https://download.tuxfamily.org/sawfish/${pname}_${version}.tar.xz";
    sha256 = "sha256-gWs8W/pMtQjbH8FEifzNAj3siZzxPd6xm8PmXXhyr10=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD

  buildInputs = [
    gdk-pixbuf-xlib
    gtk2-x11
=======
  buildInputs = [
    gdk-pixbuf-xlib
    gtk2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    for file in $out/lib/sawfish/sawfish-menu \
=======
    for i in $out/lib/sawfish/sawfish-menu \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
             $out/bin/sawfish-about \
             $out/bin/sawfish-client \
             $out/bin/sawfish-config \
             $out/bin/sawfish; do
<<<<<<< HEAD
      wrapProgram $file \
=======
      wrapProgram $i \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        --prefix REP_DL_LOAD_PATH : "$out/lib/rep" \
        --set REP_LOAD_PATH "$out/share/sawfish/lisp"
    done
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "http://sawfish.tuxfamily.org/";
    description = "An extensible, Lisp-based window manager";
    longDescription = ''
      Sawfish is an extensible window manager using a Lisp-based scripting
      language. Its policy is very minimal compared to most window managers. Its
      aim is simply to manage windows in the most flexible and attractive manner
      possible. All high-level WM functions are implemented in Lisp for future
      extensibility or redefinition.
    '';
<<<<<<< HEAD
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
=======
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
