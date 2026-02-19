{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  scdoc,
  openssl,
  zlib,
  zstd,
  luaSupport ? stdenv.hostPlatform == stdenv.buildPlatform,
  lua5_3,
}:

stdenv.mkDerivation rec {
  pname = "apk-tools";
  version = "3.0.3";

  src = fetchFromGitLab {
    domain = "gitlab.alpinelinux.org";
    owner = "alpine";
    repo = "apk-tools";
    rev = "v${version}";
    sha256 = "sha256-ydqJiLkz80TQGyf9m/l8HSXfoTAvi0av7LHETk1c0GI=";
  };

  nativeBuildInputs = [
    pkg-config
    scdoc
  ]
  ++ lib.optionals luaSupport [
    lua5_3
    lua5_3.pkgs.lua-zlib
  ];
  buildInputs = [
    openssl
    zlib
    zstd
  ]
  ++ lib.optional luaSupport lua5_3;
  strictDeps = true;

  makeFlags = [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    "SBINDIR=$(out)/bin"
    "LIBDIR=$(out)/lib"
    "LUA=${if luaSupport then "lua" else "no"}"
    "LUA_LIBDIR=$(out)/lib/lua/${lib.versions.majorMinor lua5_3.version}"
    "MANDIR=$(out)/share/man"
    "DOCDIR=$(out)/share/doc/apk"
    "INCLUDEDIR=$(out)/include"
    "PKGCONFIGDIR=$(out)/lib/pkgconfig"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=unused-result"
    "-Wno-error=deprecated-declarations"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://gitlab.alpinelinux.org/alpine/apk-tools";
    description = "Alpine Package Keeper";
    maintainers = [ ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "apk";
  };
}
