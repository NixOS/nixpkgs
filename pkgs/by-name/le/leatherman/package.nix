{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  curl,
  ruby,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "leatherman";
  version = "1.12.13";

  src = fetchFromGitHub {
    sha256 = "sha256-rfh4JLnLekx9UhyLH6eDJUeItPROmY/Lc6mcWpbGb3s=";
    rev = finalAttrs.version;
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

    # boost 1.89 removed the boost_system stub library
    substituteInPlace \
      curl/CMakeLists.txt \
      dynamic_library/CMakeLists.txt \
      execution/CMakeLists.txt \
      file_util/CMakeLists.txt \
      locale/CMakeLists.txt \
      logging/CMakeLists.txt \
      ruby/CMakeLists.txt \
      util/CMakeLists.txt \
      windows/CMakeLists.txt \
      --replace-fail ' system' ""
    substituteInPlace tests/CMakeLists.txt --replace-fail 'system ' ""
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    curl
    ruby
  ];

  meta = {
    homepage = "https://github.com/puppetlabs/leatherman/";
    description = "Collection of C++ and CMake utility libraries";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.womfoo ];
    platforms = lib.platforms.unix;
  };

})
