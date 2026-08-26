{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libacars";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "szpajder";
    repo = "libacars";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2n1tuKti8Zn5UzQHmRdvW5Q+x4CXS9QuPHFQ+DFriiE=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 3.1)" "cmake_minimum_required (VERSION 3.10)"
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = {
    homepage = "https://github.com/szpajder/libacars";
    description = "Aircraft Communications Addressing and Reporting System (ACARS) message decoder";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.mafo ];
  };
})
