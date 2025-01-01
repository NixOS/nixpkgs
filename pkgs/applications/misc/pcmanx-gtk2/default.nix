{ lib, stdenv, fetchFromGitHub, gtk2, libXft, intltool, automake, autoconf, libtool, pkg-config }:

stdenv.mkDerivation rec {
  pname = "pcmanx-gtk2";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "pcman-bbs";
    repo = "pcmanx";
    rev = version;
    sha256 = "0fbwd149wny67rfhczz4cbh713a1qnswjiz7b6c2bxfcwh51f9rc";
  };

  nativeBuildInputs = [ pkg-config automake autoconf intltool ];
  buildInputs = [ gtk2 libXft libtool ];

  preConfigure = ''
    ./autogen.sh
    # libtoolize generates configure script which uses older version of automake, we need to autoreconf it
    cd libltdl; autoreconf; cd ..
  '';

  meta = with lib; {
    homepage = "https://pcman.ptt.cc";
    license = licenses.gpl2;
    description = "Telnet BBS browser with GTK interface";
    maintainers = [ maintainers.sifmelcara ];
    platforms = platforms.linux;
    mainProgram = "pcmanx";
  };
}
