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
<<<<<<< HEAD
  version = "2.5.0";
=======
  version = "2.1.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "freebsd";
    repo = "pkg";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-bx/BPldUZHX7KYM8bYRT/p/RcLKqAXqlnCihP8Ec7NY=";
=======
    hash = "sha256-aqNJGor6gH/7XjwuT2uD7L89wn1kzsFKBMlitSVjUCM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/freebsd/pkg";
    description = "Package management tool for FreeBSD";
    maintainers = with lib.maintainers; [ qyliss ];
    platforms = with lib.platforms; darwin ++ freebsd ++ linux ++ netbsd ++ openbsd;
    license = lib.licenses.bsd2;
=======
  meta = with lib; {
    homepage = "https://github.com/freebsd/pkg";
    description = "Package management tool for FreeBSD";
    maintainers = with maintainers; [ qyliss ];
    platforms = with platforms; darwin ++ freebsd ++ linux ++ netbsd ++ openbsd;
    license = licenses.bsd2;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "pkg";
  };
})
