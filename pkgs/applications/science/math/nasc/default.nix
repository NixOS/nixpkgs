{ stdenv
, fetchFromGitHub
, fetchpatch
, pkgconfig
, vala
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
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "parnold-x";
    repo = pname;
    rev = version;
    sha256 = "036v3dx8yasp19j88lflibqnpfi5d0nk7qkcnr80zn1lvawf4wgn";
  };

  patches = [
    # fix build with gcc9
    (fetchpatch {
      url = "https://github.com/parnold-x/nasc/commit/46b9b80e228b6b86001bded45d85e073a9411549.patch";
      sha256 = "1sm2aw0xhw2chk036r231nmp2f2ypxcmzggwljkn7wfzgg3h1mx3";
    })
  ];

  nativeBuildInputs = [
    cmake
    vala
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
    homepage = "https://github.com/parnold-x/nasc";
    maintainers = with maintainers; [ samdroid-apps ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
