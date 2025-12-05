{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
  eigen,
  nlopt,
  ipopt,
  boost,
  onetbb,
  # tests pass but take 30+ minutes
  runTests ? false,
}:

stdenv.mkDerivation rec {
  pname = "pagmo2";
  version = "2.19.1";

  src = fetchFromGitHub {
    owner = "esa";
    repo = "pagmo2";
    rev = "v${version}";
    sha256 = "sha256-ido3e0hQLDEPT0AmsfAVTPlGbWe5QBkxgRO6Fg1wp/c=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    eigen
    nlopt
    boost
    onetbb
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) ipopt;

  cmakeFlags = [
    "-DPAGMO_BUILD_TESTS=${if runTests then "ON" else "OFF"}"
    "-DPAGMO_WITH_EIGEN3=yes"
    "-DPAGMO_WITH_NLOPT=yes"
    "-DNLOPT_LIBRARY=${nlopt}/lib/libnlopt${stdenv.hostPlatform.extensions.sharedLibrary}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "-DPAGMO_WITH_IPOPT=yes"
    "-DCMAKE_CXX_FLAGS='-fuse-ld=gold'"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # FIXME: fails ipopt test with Invalid_Option on darwin, so disable.
    "-DPAGMO_WITH_IPOPT=no"
    "-DLLVM_USE_LINKER=gold"
  ];

  doCheck = runTests;

  meta = with lib; {
    homepage = "https://esa.github.io/pagmo2/";
    description = "Scientific library for massively parallel optimization";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.costrouc ];
  };
}
