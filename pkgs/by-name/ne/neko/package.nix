{
  lib,
  stdenv,
  fetchFromGitHub,
  boehmgc,
  zlib,
  sqlite,
  pcre2,
  cmake,
  pkg-config,
  git,
  apacheHttpd,
  apr,
  aprutil,
  libmysqlclient,
  mbedtls,
  openssl,
  gtk3,
  libpthreadstubs,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "neko";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "HaxeFoundation";
    repo = "neko";
    rev = "v${lib.replaceStrings [ "." ] [ "-" ] version}";
    hash = "sha256-cTu+AlDnpXAow6jM77Ct9DM8p//z6N1utk7Wsd+0g9U=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    git
  ];
  buildInputs = [
    boehmgc
    zlib
    sqlite
    pcre2
    apacheHttpd
    apr
    aprutil
    libmysqlclient
    mbedtls
    openssl
    libpthreadstubs
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux gtk3;
  cmakeFlags = [ "-DRUN_LDCONFIG=OFF" ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  installCheckPhase = ''
    bin/neko bin/test.n
  '';

  # Called from tools/test.neko line 2
  # Uncaught exception - Segmentation fault
  doInstallCheck = !stdenv.hostPlatform.isDarwin;
  dontPatchELF = true;
  dontStrip = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High-level dynamically typed programming language";
    homepage = "https://nekovm.org";
    license = [
      # list based on https://github.com/HaxeFoundation/neko/blob/v2-3-0/LICENSE
      lib.licenses.gpl2Plus # nekoc, nekoml
      lib.licenses.lgpl21Plus # mysql.ndll
      lib.licenses.bsd3 # regexp.ndll
      lib.licenses.zlib # zlib.ndll
      lib.licenses.asl20 # mod_neko, mod_tora, mbedTLS
      lib.licenses.mit # overall, other libs
      "https://github.com/HaxeFoundation/neko/blob/v2-3-0/LICENSE#L24-L40" # boehm gc
    ];
    maintainers = with lib.maintainers; [
      marcweber
      locallycompact
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  };
}
