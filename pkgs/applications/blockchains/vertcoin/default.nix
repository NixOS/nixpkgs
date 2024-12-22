{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  openssl,
  boost,
  libevent,
  autoreconfHook,
  db4,
  pkg-config,
  protobuf,
  hexdump,
  zeromq,
  gmp,
  withGui,
  qtbase ? null,
  qttools ? null,
  wrapQtAppsHook ? null,
}:

stdenv.mkDerivation rec {
  pname = "vertcoin";
  version = "0.18.0";

  name = pname + toString (lib.optional (!withGui) "d") + "-" + version;

  src = fetchFromGitHub {
    owner = pname + "-project";
    repo = pname + "-core";
    rev = "2bd6dba7a822400581d5a6014afd671fb7e61f36";
    sha256 = "ua9xXA+UQHGVpCZL0srX58DDUgpfNa+AAIKsxZbhvMk=";
  };

  patches = [
    # Fix build on gcc-13 due to missing <stdexcept> headers
    (fetchpatch {
      name = "gcc-13-p1.patch";
      url = "https://github.com/vertcoin-project/vertcoin-core/commit/398768769f85cc1b6ff212ed931646b59fa1acd6.patch";
      hash = "sha256-4nnE4W0Z5HzVaJ6tB8QmyohXmt6UHUGgDH+s9bQaxhg=";
    })
    (fetchpatch {
      name = "gcc-13-p2.patch";
      url = "https://github.com/vertcoin-project/vertcoin-core/commit/af862661654966d5de614755ab9bd1b5913e0959.patch";
      hash = "sha256-4hcJIje3VAdEEpn2tetgvgZ8nVft+A64bfWLspQtbVw=";
    })
  ];

  nativeBuildInputs =
    [
      autoreconfHook
      pkg-config
      hexdump
    ]
    ++ lib.optionals withGui [
      wrapQtAppsHook
    ];

  buildInputs =
    [
      openssl
      boost
      libevent
      db4
      zeromq
      gmp
    ]
    ++ lib.optionals withGui [
      qtbase
      qttools
      protobuf
    ];

  enableParallelBuilding = true;

  configureFlags =
    [
      "--with-boost-libdir=${boost.out}/lib"
    ]
    ++ lib.optionals withGui [
      "--with-gui=qt5"
      "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
    ];

  meta = with lib; {
    description = "Digital currency with mining decentralisation and ASIC resistance as a key focus";
    homepage = "https://vertcoin.org/";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.linux;
  };
}
