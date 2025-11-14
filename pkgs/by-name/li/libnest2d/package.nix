{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  clipper,
  nlopt,
  boost,
}:

stdenv.mkDerivation {
  version = "4.12.0";
  pname = "libnest2d";

  # This revision is waiting to be merged upstream
  # Once it has been merged, this should be switched to it
  # Upstream PR: https://github.com/tamasmeszaros/libnest2d/pull/18
  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libnest2d";
    rev = "31391fd173249ad9b906390058e13b09238fadc8";
    sha256 = "1hzqi4z55x76rss3xk7hfqhy9hcaq2jaav5jqxa1aqmbvarr2gla";
  };

  postPatch = ''
    substituteInPlace {,examples/}CMakeLists.txt \
      --replace "set(CMAKE_CXX_STANDARD 11)" "set(CMAKE_CXX_STANDARD 14)"
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1)" "cmake_minimum_required(VERSION 3.10)"

  '';

  propagatedBuildInputs = [
    clipper
    nlopt
    boost
  ];
  nativeBuildInputs = [ cmake ];

  CLIPPER_PATH = "${clipper.out}";
  cmakeFlags = [ "-DLIBNEST2D_HEADER_ONLY=OFF" ];

  meta = with lib; {
    description = "2D irregular bin packaging and nesting library written in modern C++";
    homepage = "https://github.com/Ultimaker/libnest2d";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
