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

  buildInputs = [ tre ];
  propagatedBuildInputs = [ portaudio ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  postPatch = ''
    # allow compilation of C sources
    substituteInPlace CMakeLists.txt \
      --replace-fail 'project(PortAudioCpp VERSION 19.8 LANGUAGES CXX)' \
                     'project(PortAudioCpp VERSION 19.8 LANGUAGES C CXX)'

    # correct installation paths
    substituteInPlace cmake/portaudiocpp.pc.in \
      --replace-fail 'prefix=@PC_PREFIX@' \
                     'prefix=@CMAKE_INSTALL_PREFIX@' \
      --replace-fail 'libdir=''${prefix}/lib' \
                     'libdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace-fail 'includedir=''${prefix}/include' \
                     'includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@'
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
