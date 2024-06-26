{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sfml,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "csfml";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "SFML";
    repo = "CSFML";
    rev = finalAttrs.version;
    hash = "sha256-ECt0ySDpYWF0zuDBSnQzDwUm4Xj4z1+XSC55D6yivac=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ sfml ];
  cmakeFlags = [ "-DCMAKE_MODULE_PATH=${sfml}/share/SFML/cmake/Modules/" ];

  prePatch = ''
    substituteInPlace tools/pkg-config/* \
      --replace-fail 'libdir=''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@' "libdir=@CMAKE_INSTALL_FULL_LIBDIR@"
  '';

  meta = {
    homepage = "https://www.sfml-dev.org/";
    description = "Simple and fast multimedia library";
    longDescription = ''
      SFML is a simple, fast, cross-platform and object-oriented multimedia API.
      It provides access to windowing, graphics, audio and network.
      It is written in C++, and has bindings for various languages such as C, .Net, Ruby, Python.
    '';
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ drawbu jpdoyle ];
    platforms = lib.platforms.unix;
  };
})
