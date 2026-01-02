{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnoise";
  version = "0-unstable-2024-09-01";

  src = fetchFromGitHub {
    owner = "qknight";
    repo = "libnoise";
    rev = "9ce0737b55812f7de907e86dc633724524e3a8e8";
    hash = "sha256-coazd4yedH69b+TOSTFV1CEzN0ezjoGyOaYR9QBhp2E=";
  };

  # cmake 4 compatibility
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail "cmake_minimum_required(VERSION 3.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  # Ensure CMake runs on the build machine in cross builds.
  nativeBuildInputs = [
    (if stdenv.buildPlatform != stdenv.hostPlatform then buildPackages.cmake else cmake)
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ];

  # Upstream installs libraries into the bindir; put them in libdir for sane consumers.
  postInstall = ''
    if [ -d "$out/bin" ]; then
      mkdir -p "$out/lib"

      # Unix: shared libraries
      mv -v "$out/bin/"libnoise*.so* "$out/lib/" 2>/dev/null || true
      mv -v "$out/bin/"libnoise*.dylib* "$out/lib/" 2>/dev/null || true

      # MinGW: import libraries should live in libdir (keep DLLs in bindir)
      mv -v "$out/bin/"*.dll.a "$out/lib/" 2>/dev/null || true
    fi
  '';

  meta = {
    description = "Portable, open-source, coherent noise-generating library for C++";
    homepage = "https://github.com/qknight/libnoise";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
