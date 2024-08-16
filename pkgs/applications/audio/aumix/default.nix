{ lib
, stdenv
, fetchurl
, fetchpatch
, gettext
, ncurses
, gtkGUI ? false
, pkg-config
, gtk2
}:

stdenv.mkDerivation rec {
  pname = "aumix";
  version = "2.9.1";

  src = fetchurl {
    url = "http://www.jpj.net/~trevor/aumix/releases/aumix-${version}.tar.bz2";
    sha256 = "0a8fwyxnc5qdxff8sl2sfsbnvgh6pkij4yafiln0fxgg6bal7knj";
  };

  patches = [
    # Pull Gentoo fix for -fno-common toolchains. Upstream does not
    # seem to have the contacts
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-sound/aumix/files/aumix-2.9.1-fno-common.patch?id=496c9ec7355f06f6d1d19be780a6981503e6df1f";
      sha256 = "0qwylhx1hawsmx1pc7ykrjq9phksc73dq9rss6ggq15n3ggnc95y";
    })
  ];

  nativeBuildInputs = lib.optionals gtkGUI [ pkg-config ];

  buildInputs = [ gettext ncurses ]
    ++ lib.optionals gtkGUI [ gtk2 ];

  configureFlags = lib.optionals (!gtkGUI) ["--without-gtk"];

  meta = with lib; {
    description = "Audio mixer for X and the console";
    longDescription = ''
      Aumix adjusts an audio mixer from X, the console, a terminal,
      the command line or a script.
    '';
    homepage = "http://www.jpj.net/~trevor/aumix.html";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
