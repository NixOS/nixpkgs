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
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    curl
    leatherman
  ];

  meta = {
    inherit (src.meta) homepage;
    description = "C++ port of the Typesafe Config library";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.womfoo ];
    platforms = lib.platforms.unix;
  };

}
