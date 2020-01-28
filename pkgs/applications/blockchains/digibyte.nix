{ stdenv
, fetchFromGitHub
, openssl
, boost
, libevent
, autoreconfHook
, db4
, pkgconfig
, protobuf
, hexdump
, zeromq
, withGui
, qtbase ? null
, qttools ? null
, wrapQtAppsHook ? null
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "digibyte";
  version = "7.17.2";

  name = pname + toString (optional (!withGui) "d") + "-" + version;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "04czj7mx3wpbx4832npk686p9pg5zb6qwlcvnmvqf31hm5qylbxj";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    hexdump
  ] ++ optionals withGui [
    wrapQtAppsHook
  ];

  buildInputs = [
    openssl
    boost
    libevent
    db4
    zeromq
  ] ++ optionals withGui [
    qtbase
    qttools
    protobuf
  ];

  enableParallelBuilding = true;

  configureFlags = [
      "--with-boost-libdir=${boost.out}/lib"
  ] ++ optionals withGui [
      "--with-gui=qt5"
      "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
  ];

  meta = {
    description = "DigiByte (DGB) is a rapidly growing decentralized, global blockchain";
    homepage = "https://digibyte.io/";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.linux;
  };
}
