{
  lib,
  stdenv,
  fetchFromGitHub,
  automake,
  autoconf,
  libtool,
  autoreconfHook,
  gmpxx,
}:
stdenv.mkDerivation rec {
  pname = "givaro";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "linbox-team";
    repo = "givaro";
    tag = "v${version}";
    sha256 = "sha256-vSkWmKqpbVk1qdsqCU7qF7o+YgV5YRc9p4mlgl6yrto=";
  };

  patches = [
    # skip gmp version check for cross-compiling, our version is new enough
    ./skip-gmp-check.patch
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    autoconf
    automake
  ];
  buildInputs = [ libtool ];
  propagatedBuildInputs = [ gmpxx ];

  configureFlags = [
    "--without-archnative"
    "CCNAM=${stdenv.cc.cc.pname}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    # disable SIMD instructions (which are enabled *when available* by default)
    "--${if stdenv.hostPlatform.sse3Support then "enable" else "disable"}-sse3"
    "--${if stdenv.hostPlatform.ssse3Support then "enable" else "disable"}-ssse3"
    "--${if stdenv.hostPlatform.sse4_1Support then "enable" else "disable"}-sse41"
    "--${if stdenv.hostPlatform.sse4_2Support then "enable" else "disable"}-sse42"
    "--${if stdenv.hostPlatform.avxSupport then "enable" else "disable"}-avx"
    "--${if stdenv.hostPlatform.avx2Support then "enable" else "disable"}-avx2"
    "--${if stdenv.hostPlatform.fmaSupport then "enable" else "disable"}-fma"
    "--${if stdenv.hostPlatform.fma4Support then "enable" else "disable"}-fma4"
  ];

  # On darwin, tests are linked to dylib in the nix store, so we need to make
  # sure tests run after installPhase.
  doInstallCheck = true;
  installCheckTarget = "check";
  doCheck = false;

  meta = {
    description = "C++ library for arithmetic and algebraic computations";
    homepage = "https://casys.gricad-pages.univ-grenoble-alpes.fr/givaro/";
    mainProgram = "givaro-config";
    license = lib.licenses.cecill-b;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
  };
}
