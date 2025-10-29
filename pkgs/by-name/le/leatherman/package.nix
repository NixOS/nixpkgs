{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  curl,
  ruby,
}:

stdenv.mkDerivation rec {
  pname = "leatherman";
  version = "1.12.13";

  src = fetchFromGitHub {
    sha256 = "sha256-rfh4JLnLekx9UhyLH6eDJUeItPROmY/Lc6mcWpbGb3s=";
    rev = version;
    repo = "leatherman";
    owner = "puppetlabs";
  };

  cmakeFlags = [ "-DLEATHERMAN_ENABLE_TESTING=OFF" ];

  # CMake4 3.2.2 is deprecated and no longer supported by CMake > 4
  # https://github.com/NixOS/nixpkgs/issues/445447
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 3.2.2)" \
      "cmake_minimum_required(VERSION 3.10)"
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    curl
    ruby
  ];

  meta = with lib; {
    homepage = "https://github.com/puppetlabs/leatherman/";
    description = "Collection of C++ and CMake utility libraries";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.unix;
  };

}
