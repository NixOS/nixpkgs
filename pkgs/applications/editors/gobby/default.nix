{
  avahiSupport ? false, # build support for Avahi in libinfinity
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  pkg-config,
  wrapGAppsHook3,
  yelp-tools,
  gtkmm3,
  gsasl,
  gtksourceview3,
  libxmlxx,
  libinfinity,
  intltool,
  itstool,
}:

let
  libinf = libinfinity.override {
    gtkWidgets = true;
    inherit avahiSupport;
  };
in
stdenv.mkDerivation rec {
  pname = "gobby";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "gobby";
    repo = "gobby";
    rev = "v${version}";
    sha256 = "06cbc2y4xkw89jaa0ayhgh7fxr5p2nv3jjs8h2xcbbbgwaw08lk0";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
    intltool
    itstool
    yelp-tools
    wrapGAppsHook3
  ];
  buildInputs = [
    gtkmm3
    gsasl
    gtksourceview3
    libxmlxx
    libinf
  ];

  preConfigure = "./autogen.sh";

  meta = with lib; {
    homepage = "http://gobby.0x539.de/";
    description = "A GTK-based collaborative editor supporting multiple documents in one session and a multi-user chat";
    mainProgram = "gobby-0.5";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
