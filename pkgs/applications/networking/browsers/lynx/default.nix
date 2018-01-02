{ stdenv, buildPackages
, fetchurl, pkgconfig, ncurses, gzip
, sslSupport ? true, openssl ? null
, buildPlatform, hostPlatform
, nukeReferences
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation rec {
  name = "lynx-${version}";
  version = "2.8.9dev.16";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/lynx/tarballs/lynx${version}.tar.bz2"
      "https://invisible-mirror.net/archives/lynx/tarballs/lynx${version}.tar.bz2"
    ];
    sha256 = "1j0vx871ghkm7fgrafnvd2ml3ywcl8d3gyhq02fhfb851c88lc84";
  };

  enableParallelBuilding = true;

  hardeningEnable = [ "pie" ];

  configureFlags = [ "--enable-widec" ] ++ stdenv.lib.optional sslSupport "--with-ssl";

  nativeBuildInputs = stdenv.lib.optional sslSupport pkgconfig
    ++ stdenv.lib.optional (hostPlatform != buildPlatform) buildPackages.stdenv.cc
    ++ [ nukeReferences ];

  buildInputs = [ ncurses gzip ] ++ stdenv.lib.optional sslSupport openssl.dev;

  # cfg_defs.h captures lots of references to build-only dependencies, derived
  # from config.cache.
  postConfigure = ''
    make cfg_defs.h
    nuke-refs cfg_defs.h
  '';

  meta = with stdenv.lib; {
    description = "A text-mode web browser";
    homepage = http://lynx.invisible-island.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
