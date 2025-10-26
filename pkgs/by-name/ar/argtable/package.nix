{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "argtable";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "argtable";
    repo = "argtable3";
    tag = "v" + finalAttrs.version;
    hash = "sha256-IW4pqOHKjwxQEmv/V40kIRLin+bQE6PAlfJemFgi5bQ=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ];

  postPatch = ''
    patchShebangs tools/build

    substituteInPlace pkgconfig.pc.in \
      --replace-fail "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" "@CMAKE_INSTALL_FULL_INCLUDEDIR@" \
      --replace-fail "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" "@CMAKE_INSTALL_FULL_LIBDIR@"
  '';

  meta = {
    homepage = "https://github.com/argtable/argtable3";
    description = "Single-file, ANSI C command-line parsing library";
    longDescription = ''
      Argtable is an open source ANSI C library that parses GNU-style
      command-line options. It simplifies command-line parsing by defining a
      declarative-style API that you can use to specify what your command-line
      syntax looks like. Argtable will automatically generate consistent error
      handling logic and textual descriptions of the command line syntax, which
      are essential but tedious to implement for a robust CLI program.
    '';
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
# TODO: a NixOS test suite
# TODO: multiple outputs
# TODO: documentation
# TODO: build both shared and static libs
