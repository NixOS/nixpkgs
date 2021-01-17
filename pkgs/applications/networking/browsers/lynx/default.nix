{ lib, stdenv, buildPackages
, fetchurl, pkg-config, ncurses, gzip
, sslSupport ? true, openssl ? null
, nukeReferences
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation rec {
  pname = "lynx";
  version = "2.8.9rel.1";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/lynx/tarballs/lynx${version}.tar.bz2"
      "https://invisible-mirror.net/archives/lynx/tarballs/lynx${version}.tar.bz2"
    ];
    sha256 = "15cmyyma2kz1hfaa6mwjgli8zwdzq3jv0q2cl6nwzycjfwyijzrq";
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

  buildInputs = [ ncurses gzip ] ++ lib.optional sslSupport openssl.dev;

  # cfg_defs.h captures lots of references to build-only dependencies, derived
  # from config.cache.
  postConfigure = ''
    make cfg_defs.h
    nuke-refs cfg_defs.h
  '';

  meta = with lib; {
    description = "A text-mode web browser";
    homepage = "https://lynx.invisible-island.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
