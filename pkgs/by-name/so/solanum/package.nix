{
  lib,
  stdenv,
  autoconf,
  automake,
  libtool,
  bison,
  fetchFromGitHub,
  flex,
  lksctp-tools,
  openssl,
  pkg-config,
  sqlite,
  util-linux,
  unstableGitUpdater,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "solanum";
  version = "0-unstable-2026-03-22";

  src = fetchFromGitHub {
    owner = "solanum-ircd";
    repo = "solanum";
    rev = "6ac4d0e24e4b872b9f30adc743cf743e964d75d1";
    hash = "sha256-5pW3QkSkmLoRrW/WjsDm4zCJLjwG0KVBKWbQe/iIgnM=";
  };

  patches = [
    ./dont-create-logdir.patch
  ];

  postPatch = ''
    substituteInPlace include/defaults.h --replace-fail 'ETCPATH "' '"/etc/solanum'
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [
    "--enable-epoll"
    "--enable-ipv6"
    "--enable-openssl=${openssl.dev}"
    "--with-program-prefix=solanum-"
    "--localstatedir=/var"
    "--with-rundir=/run"
    "--with-logdir=/var/log"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    "--enable-sctp=${lksctp-tools.out}/lib"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    bison
    flex
    pkg-config
    util-linux
  ];

  buildInputs = [
    openssl
    sqlite
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  enableParallelBuilding = true;
  # Missing install depends:
  #   ...-binutils-2.40/bin/ld: cannot find ./.libs/libircd.so: No such file or directory
  #   collect2: error: ld returned 1 exit status
  #   make[4]: *** [Makefile:634: solanum] Error 1
  enableParallelInstalling = false;

  passthru = {
    tests = { inherit (nixosTests) solanum; };
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "IRCd for unified networks";
    homepage = "https://github.com/solanum-ircd/solanum";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.unix;
  };
}
