{ stdenv, fetchgit, pkgconfig, gettext, libtool, automake, autoconf, cairo, gtk2, autoreconfHook }:

stdenv.mkDerivation {
  pname = "gerbv";
  version = "2015-10-08";

  src = fetchgit {
    url = "git://git.geda-project.org/gerbv.git";
    rev = "76b8b67bfa10823ce98f1c4c3b49a2afcadf7659";
    sha256 = "00jn1xhf6kblxc5gac1wvk8zm12fy6sk81nj3jwdag0z6wk3z446";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ gettext libtool automake autoconf cairo gtk2 ];

  configureFlags = ["--disable-update-desktop-database"];

  meta = with stdenv.lib; {
    description = "A Gerber (RS-274X) viewer";
    homepage = "http://gerbv.geda-project.org/";
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
