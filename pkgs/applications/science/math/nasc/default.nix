{ stdenv
, fetchFromGitHub
, pkgconfig
, gtk3
, glib
, pantheon
, libsoup
, gtksourceview
, libgee
, cmake
, libqalculate
, cln
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "nasc";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "parnold-x";
    repo = pname;
    rev = version;
    sha256 = "009xmlsgl7r6wp6sczbdp8sjqqd6k2mychx5b4zn7wnrl7435y5y";
  };

  nativeBuildInputs = [
    cmake
    pantheon.vala
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    cln
    libsoup
    gtk3
    glib
    gtksourceview
    libgee
    libqalculate
    pantheon.elementary-icon-theme
    pantheon.granite
  ];

  meta = with stdenv.lib; {
    description = "Do maths like a normal person";
    longDescription = ''
      It’s an app where you do maths like a normal person. It lets you
      type whatever you want and smartly figures out what is math and
      spits out an answer on the right pane. Then you can plug those
      answers in to future equations and if that answer changes, so does
      the equations it’s used in.
    '';
    homepage = https://github.com/parnold-x/nasc;
    maintainers = with maintainers; [ samdroid-apps ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
