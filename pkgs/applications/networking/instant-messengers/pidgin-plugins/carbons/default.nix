{ stdenv, libxml2, pidgin, pkgconfig, fetchFromGitHub } :

stdenv.mkDerivation rec {
  pname = "pidgin-carbons";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "gkdr";
    repo  = "carbons";
    rev   = "v${version}";
    sha256 = "1aq9bwgpmbwrigq6ywf0pjkngqcm0qxncygaj1fi57npjhcjs6ln";
  };

  makeFlags = [ "PURPLE_PLUGIN_DIR=$(out)/lib/pidgin" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libxml2 pidgin ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/gkdr/carbons";
    description = "XEP-0280: Message Carbons plugin for libpurple";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
