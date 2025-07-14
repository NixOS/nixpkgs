{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "libacars";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "szpajder";
    repo = "libacars";
    tag = "v${version}";
    hash = "sha256-2n1tuKti8Zn5UzQHmRdvW5Q+x4CXS9QuPHFQ+DFriiE=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = with lib; {
    homepage = "https://github.com/szpajder/libacars";
    description = "Aircraft Communications Addressing and Reporting System (ACARS) message decoder";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.mafo ];
  };
}
