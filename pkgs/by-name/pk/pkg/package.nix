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
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "freebsd";
    repo = "pkg";
    rev = finalAttrs.version;
    hash = "sha256-aqNJGor6gH/7XjwuT2uD7L89wn1kzsFKBMlitSVjUCM=";
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

  meta = with lib; {
    homepage = "https://github.com/freebsd/pkg";
    description = "Package management tool for FreeBSD";
    maintainers = with maintainers; [ qyliss ];
    platforms = with platforms; darwin ++ freebsd ++ linux ++ netbsd ++ openbsd;
    license = licenses.bsd2;
    mainProgram = "pkg";
  };
})
