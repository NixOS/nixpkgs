{
  lib,
  stdenv,
  fetchFromGitHub,
  m4,
  pkg-config,
  tcl,
  bzip2,
  elfutils,
  libarchive,
  libbsd,
  xz,
  openssl,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pkg";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "freebsd";
    repo = "pkg";
    rev = finalAttrs.version;
    hash = "sha256-bx/BPldUZHX7KYM8bYRT/p/RcLKqAXqlnCihP8Ec7NY=";
  };

  setOutputFlags = false;
  separateDebugInfo = true;

  nativeBuildInputs = [
    m4
    pkg-config
    tcl
  ];
  buildInputs = [
    bzip2
    elfutils
    libarchive
    openssl
    xz
    zlib
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libbsd;

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/etc
  '';

  meta = {
    homepage = "https://github.com/freebsd/pkg";
    description = "Package management tool for FreeBSD";
    maintainers = with lib.maintainers; [ qyliss ];
    platforms = with lib.platforms; darwin ++ freebsd ++ linux ++ netbsd ++ openbsd;
    license = lib.licenses.bsd2;
    mainProgram = "pkg";
  };
})
