{
  lib,
  stdenv,
  pkgsStatic,
  fetchurl,
  fetchpatch2,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "nmap";
  version = "7.991";

  src = fetchurl {
    url = "https://nmap.org/dist/nmap-${finalAttrs.version}.tar.bz2";
    hash = "sha256-pdUH8pQ3vvO+3Udx/5qqj8HCoQnduh9bHPEgJ0VpKb4=";
  };

  patches = [
    (fetchpatch2 {
      name = "Do-not-call-NSE-if-compiling-without-Lua-support.patch";
      url = "https://github.com/nmap/nmap/commit/4c36cf12f246b52a8d510bdde8becd5c5b3bf8b5.patch";
      hash = "sha256-aWPHfJF1wOE5l6LQUKCqKVKxBoyNFov3r0NGEOxWpw8=";
    })
  ];

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
    libssh2
    libpcap
    openssl
    zlib
  ]
  ++ lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
    # If we omit liblinear, nmap will build it from vendored sources, which they patch for broader
    # platform support v.s. upstream liblinear (e.g. it supports static linking).
    liblinear
  ];

  enableParallelBuilding = true;

  doCheck = false; # fails 3 tests, probably needs the net

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "-V";
  doInstallCheck = true;

  passthru.tests = {
    static = pkgsStatic.nmap;
  };

  meta = {
    description = "Free and open source utility for network discovery and security auditing";
    homepage = "http://www.nmap.org";
    changelog = "https://nmap.org/changelog.html#${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    mainProgram = "nmap";
    maintainers = with lib.maintainers; [
      thoughtpolice
      fpletz
    ];
  };
})
