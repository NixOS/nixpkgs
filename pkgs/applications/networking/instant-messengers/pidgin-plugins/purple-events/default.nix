{ stdenv, fetchFromGitHub, pidgin, glib, autoreconfHook, pkgconfig, intltool }:

stdenv.mkDerivation rec {
  pname = "purple-events";
  version = "2017-08-25";

  src = fetchFromGitHub {
    owner = "sardemff7";
    repo = pname;
    rev = "7b01b0a2724f675dadf41a8d8e9bee203ef1ccc2";
    sha256 = "1mhg40swa12inkdhhxf6x9c45h2dijzvdlx1325zgvs2k1vv0a3k";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig intltool ];
  autoreconfPhase = "${stdenv.shell} ./autogen.sh";
  buildInputs = [ pidgin glib ];

  configureFlags = [ "--with-purple-plugindir=${placeholder "out"}/lib/purple-2" ];

  meta = with stdenv.lib; {
    homepage = http://purple-events.sardemff7.net/;
    description = "libpurple events handling plugin and library";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
