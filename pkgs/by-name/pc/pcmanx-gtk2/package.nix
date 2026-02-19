{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk2,
  libxft,
  intltool,
  automake,
  autoconf,
  libtool,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pcmanx-gtk2";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "pcman-bbs";
    repo = "pcmanx";
    rev = finalAttrs.version;
    sha256 = "0fbwd149wny67rfhczz4cbh713a1qnswjiz7b6c2bxfcwh51f9rc";
  };

  nativeBuildInputs = [
    pkg-config
    automake
    autoconf
    intltool
  ];
  buildInputs = [
    gtk2
    libxft
    libtool
  ];

  preConfigure = ''
    ./autogen.sh
    # libtoolize generates configure script which uses older version of automake, we need to autoreconf it
    cd libltdl; autoreconf; cd ..
  '';

  meta = {
    homepage = "https://pcman.ptt.cc";
    license = lib.licenses.gpl2;
    description = "Telnet BBS browser with GTK interface";
    maintainers = [ lib.maintainers.sifmelcara ];
    platforms = lib.platforms.linux;
    mainProgram = "pcmanx";
  };
})
