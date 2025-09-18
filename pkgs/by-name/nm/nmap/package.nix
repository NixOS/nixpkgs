{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
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
  version = "7.98";

  src = fetchurl {
    url = "https://nmap.org/dist/nmap-${version}.tar.bz2";
    hash = "sha256-zoRzE+qunlyfIXCOQtKre1bH4OuIA3KaMJL1iIbYl+Y=";
  };

  prePatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
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

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "-V";
  doInstallCheck = true;

  meta = {
    description = "Free and open source utility for network discovery and security auditing";
    homepage = "http://www.nmap.org";
    changelog = "https://nmap.org/changelog.html#${version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      thoughtpolice
      fpletz
    ];
  };
}
