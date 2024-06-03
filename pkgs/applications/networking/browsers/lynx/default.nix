{ lib
, stdenv
, buildPackages
, fetchurl
, pkg-config
, ncurses
, gzip
, sslSupport ? true
, openssl
, nukeReferences
}:

stdenv.mkDerivation rec {
  pname = "lynx";
  version = "2.9.0dev.12";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/lynx/tarballs/lynx${version}.tar.bz2"
      "https://invisible-mirror.net/archives/lynx/tarballs/lynx${version}.tar.bz2"
    ];
    hash = "sha256-pkVbFZ0Ad22OwQUShcly3B8MVS0FcaDP8Coj7BRu6OU=";
  };

  enableParallelBuilding = true;

  hardeningEnable = [ "pie" ];

  configureFlags = [
    "--enable-default-colors"
    "--enable-widec"
    "--enable-ipv6"
  ] ++ lib.optional sslSupport "--with-ssl";

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ nukeReferences ]
    ++ lib.optional sslSupport pkg-config;

  buildInputs = [ ncurses gzip ]
    ++ lib.optional sslSupport openssl;

  # cfg_defs.h captures lots of references to build-only dependencies, derived
  # from config.cache.
  postConfigure = ''
    make cfg_defs.h
    nuke-refs cfg_defs.h
  '';

  meta = with lib; {
    description = "A text-mode web browser";
    homepage = "https://lynx.invisible-island.net/";
    mainProgram = "lynx";
    maintainers = with maintainers; [ ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
