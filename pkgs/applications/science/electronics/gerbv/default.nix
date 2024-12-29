{ lib
, stdenv
, autoconf
, automake
, autoreconfHook
, cairo
, fetchFromGitHub
, gettext
, gtk2-x11
, libtool
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "gerbv";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "gerbv";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-sr48RGLYcMKuyH9p+5BhnR6QpKBvNOqqtRryw3+pbBk=";
  };

  postPatch = ''
    sed -i '/AC_INIT/s/m4_esyscmd.*/${version}])/' configure.ac
  '';

  nativeBuildInputs = [
    autoconf
    automake
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    cairo
    gettext
    gtk2-x11
    libtool
  ];

  configureFlags = [
    "--disable-update-desktop-database"
  ];

  meta = with lib; {
    description = "Gerber (RS-274X) viewer";
    mainProgram = "gerbv";
    homepage = "https://gerbv.github.io/";
    changelog = "https://github.com/gerbv/gerbv/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ mog ];
    platforms = platforms.unix;
  };
}
