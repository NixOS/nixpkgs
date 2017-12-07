{ stdenv, libxml2, pidgin, pkgconfig, fetchFromGitHub } :

stdenv.mkDerivation rec {
  name = "pidgin-carbons-${version}";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "gkdr";
    repo  = "carbons";
    rev   = "v${version}";
    sha256 = "05hcqvsirb7gnpfcszsrgal5q7dajl2wdi2dy7c41zgl377syavw";
  };

  makeFlags = [ "PURPLE_PLUGIN_DIR=$(out)/lib/pidgin" ];

  buildInputs = [ libxml2 pidgin pkgconfig ];

  meta = with stdenv.lib; {
    homepage = https://github.com/gkdr/carbons;
    description = "XEP-0280: Message Carbons plugin for libpurple";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jb55 ];
  };
}
