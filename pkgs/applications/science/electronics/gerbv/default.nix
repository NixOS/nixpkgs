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
  version = "2.9.8";

  src = fetchFromGitHub {
    owner = "gerbv";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-6r9C5qDOXsQoLsYMSCuIS01gI0ijH7WDoepcowo1yQw=";
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
    description = "A Gerber (RS-274X) viewer";
    homepage = "https://gerbv.github.io/";
    changelog = "https://github.com/gerbv/gerbv/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ mog ];
    platforms = platforms.unix;
  };
}
