{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libspatialindex";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "libspatialindex";
    repo = "libspatialindex";
    rev = finalAttrs.version;
    hash = "sha256-a2CzRLHdQMnVhHZhwYsye4X644r8gp1m6vU2CJpSRpU=";
  };

  patches = [
    ./no-rpath-for-darwin.diff
  ];

  postPatch = ''
    patchShebangs test/
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)

    # The cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR
    # correctly (setting it to an absolute path causes include files to go to
    # $out/$out/include,  because the absolute path is interpreted with root
    # at $out).
    # See: https://github.com/NixOS/nixpkgs/issues/144170
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  doCheck = true;

  meta = {
    description = "Extensible spatial index library in C++";
    homepage = "https://libspatialindex.org";
    license = lib.licenses.mit;
    teams = [ lib.teams.geospatial ];
    platforms = lib.platforms.unix;
  };
})
