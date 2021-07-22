{ lib, stdenv, fetchFromGitHub, openssl, boost, libevent, autoreconfHook
, db4, pkg-config, protobuf, hexdump, zeromq, withGui ? true, qtbase
, qttools, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  name = "digibyte${lib.optionalString (!withGui) "d"}";
  version = "7.17.3";

  src = fetchFromGitHub {
    owner = "DigiByte-Core";
    repo = "digibyte";
    rev = "v${version}";
    sha256 = "0hzsjf70ksbh3f9gp1fpg7b98liymiyf51n6sv0cgnwxd85jgz6c";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    hexdump
  ] ++ lib.optionals withGui [
    wrapQtAppsHook
  ];

  buildInputs = [
    openssl
    boost
    libevent
    db4
    zeromq
  ] ++ lib.optionals withGui [
    qtbase
    qttools
    protobuf
  ];

  enableParallelBuilding = true;

  configureFlags = [
      "--with-boost-libdir=${boost.out}/lib"
  ] ++ lib.optionals withGui [
      "--with-gui=qt5"
      "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
  ];

  postInstall = ''
    rm $out/bin/test_* $out/bin/bench_*
  '';

  dontWrapQtApps = withGui;
  preFixup = lib.optionalString withGui ''
    wrapQtApp $out/bin/digibyte-qt
  '';

  meta = with lib; {
    description = "DigiByte (DGB) is a rapidly growing decentralized, global blockchain";
    homepage = "https://digibyte.io/";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.linux;
  };
}
