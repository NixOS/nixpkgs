{
  lib,
  stdenv,
  fetchurl,
  libpcap,
  pkg-config,
  openssl,
  lua5_4,
  pcre2,
  liblinear,
  libssh2,
  zlib,
  withLua ? true,
}:

stdenv.mkDerivation rec {
  pname = "nmap";
  version = "7.95";

  src = fetchurl {
    url = "https://nmap.org/dist/nmap-${version}.tar.bz2";
    hash = "sha256-4Uq1MOR7Wv2I8ciiusf4nNj+a0eOItJVxbm923ocV3g=";
  };

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace libz/configure \
        --replace /usr/bin/libtool ar \
        --replace 'AR="libtool"' 'AR="ar"' \
        --replace 'ARFLAGS="-o"' 'ARFLAGS="-r"'
  '';

  configureFlags = [
    (if withLua then "--with-liblua=${lua5_4}" else "--without-liblua")
    "--without-ndiff"
    "--without-zenmap"
  ];

  postInstall = ''
    install -m 444 -D nselib/data/passwords.lst $out/share/wordlists/nmap.lst
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change liblinear.so.5 ${liblinear.out}/lib/liblinear.5.dylib $out/bin/nmap
  '';

  makeFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "AR=${stdenv.cc.bintools.targetPrefix}ar"
    "RANLIB=${stdenv.cc.bintools.targetPrefix}ranlib"
    "CC=${stdenv.cc.targetPrefix}gcc"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    pcre2
    liblinear
    libssh2
    libpcap
    openssl
    zlib
  ];

  enableParallelBuilding = true;

  doCheck = false; # fails 3 tests, probably needs the net

  meta = {
    description = "Free and open source utility for network discovery and security auditing";
    homepage = "http://www.nmap.org";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      thoughtpolice
      fpletz
    ];
  };
}
