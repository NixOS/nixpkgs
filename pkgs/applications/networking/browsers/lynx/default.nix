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
, fetchpatch
}:

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

  patches = [
    (fetchpatch {
      name = "CVE-2021-38165.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/lynx/CVE-2021-38165.patch?id=3400945dbbb8a87065360963e4caa0e17d3dcc61";
      sha256 = "1aykb9y2g2vdpbbpvjlm4r40x7py2yv6jbywwcqcxrlciqcw4x57";
    })
  ];

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
