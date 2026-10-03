{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rttr";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "rttrorg";
    repo = "rttr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-V0aC6DSL2FQKpvZGXaVWkqOuc42GI29hOZEDIjVqqvs=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_UNIT_TESTS=OFF"
    "-DBUILD_PACKAGE=OFF"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 3.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "C++ Reflection Library";
    homepage = "https://www.rttr.org";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
