{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  curl,
  leatherman,
}:

stdenv.mkDerivation rec {
  pname = "cpp-hocon";
  version = "0.3.0";

  src = fetchFromGitHub {
    sha256 = "0b24anpwkmvbsn5klnr58vxksw00ci9pjhwzx7a61kplyhsaiydw";
    rev = version;
    repo = "cpp-hocon";
    owner = "puppetlabs";
  };

  postPatch = ''
    sed -i -e '/add_subdirectory(tests)/d' lib/CMakeLists.txt

    # CMake 3.2.2 is deprecated and no longer supported by CMake > 4
    # https://github.com/NixOS/nixpkgs/issues/445447
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 3.2.2)" \
      "cmake_minimum_required(VERSION 3.10)"
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    curl
    leatherman
  ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "C++ port of the Typesafe Config library";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.unix;
  };

}
