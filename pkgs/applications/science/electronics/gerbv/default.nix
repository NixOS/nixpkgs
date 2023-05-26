{ lib, stdenv, fetchFromGitHub, pkg-config, gettext, libtool, automake, autoconf, cairo, gtk2-x11, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "gerbv";
  version = "2.9.6";

  src = fetchFromGitHub {
    owner = "gerbv";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HNhrnXOBlzfO/roWzTsg0RcJPb0c7RuJepankB5zNts=";
  };

  postPatch = ''
    sed -i '/AC_INIT/s/m4_esyscmd.*/${version}])/' configure.ac
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config automake autoconf ];
  buildInputs = [ gettext libtool cairo gtk2-x11 ];

  configureFlags = ["--disable-update-desktop-database"];

  meta = with lib; {
    description = "A Gerber (RS-274X) viewer";
    homepage = "https://gerbv.github.io/";
    changelog = "https://github.com/gerbv/gerbv/releases/tag/v${version}";
    maintainers = with maintainers; [ mog ];
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
