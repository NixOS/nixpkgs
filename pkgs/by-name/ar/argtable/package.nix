{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "argtable";
  version = "3.2.2";
  srcVersion = "v${finalAttrs.version}.f25c624";

  src = fetchFromGitHub {
    owner = "argtable";
    repo = "argtable3";
    rev = finalAttrs.srcVersion;
    hash = "sha256-X89xFLDs6NEgjzzwy8kplvTgukQd/CV3Xa9A3JXecf4=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ];

  postPatch = ''
    patchShebangs tools/build
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
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
# TODO: a NixOS test suite
# TODO: multiple outputs
# TODO: documentation
# TODO: build both shared and static libs
