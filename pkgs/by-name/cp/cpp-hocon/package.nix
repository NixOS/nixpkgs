{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  curl,
  leatherman,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpp-hocon";
  version = "0.3.0";

  src = fetchFromGitHub {
    sha256 = "0b24anpwkmvbsn5klnr58vxksw00ci9pjhwzx7a61kplyhsaiydw";
    rev = finalAttrs.version;
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

    # boost 1.89 removed the boost_system stub library
    substituteInPlace CMakeLists.txt --replace-fail \
      'list(APPEND BOOST_COMPONENTS thread date_time chrono filesystem system program_options)' \
      'list(APPEND BOOST_COMPONENTS thread date_time chrono filesystem program_options)'
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    curl
    leatherman
  ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "C++ port of the Typesafe Config library";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.womfoo ];
    platforms = lib.platforms.unix;
  };

})
