{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ois";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "wgois";
    repo = "OIS";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ir6p+Tzf8L5VOW/rsG4yelsth7INbhABO2T7pfMHcFo=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libx11 ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  patches = [
    # CMake 4 dropped support of versions lower than 3.5,
    # versions lower than 3.10 are deprecated.
    ./cmake4.patch
  ];

  meta = {
    description = "Object-oriented C++ input system";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.zlib;
  };
})
