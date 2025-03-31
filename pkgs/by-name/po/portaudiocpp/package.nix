{
  lib,
  stdenv,
  portaudio,
  cmake,
  pkg-config,
  tre,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "portaudiocpp";
  inherit (portaudio) version src;

  outputs = [
    "out"
    "dev"
  ];

  sourceRoot = "${finalAttrs.src.name}/bindings/cpp";

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    portaudio
    tre
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  postPatch = ''
    # allow compilation of C sources
    sed -E -i 's/^(project\(.* LANGUAGES CXX)\)$/\1 C)/' \
      CMakeLists.txt

    # correct installation paths
    sed -E -i \
      -e 's/^(prefix=).*/\1@CMAKE_INSTALL_PREFIX@/' \
      -e 's/^(libdir=).*/\1@CMAKE_INSTALL_FULL_LIBDIR@/' \
      -e 's/^(includedir=).*/\1@CMAKE_INSTALL_FULL_INCLUDEDIR@/' \
      cmake/portaudiocpp.pc.in
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "PortAudio C++ bindings";
    inherit (portaudio.meta)
      homepage
      changelog
      license
      maintainers
      platforms
      ;

    pkgConfigModules = [ "portaudiocpp" ];
  };
})
