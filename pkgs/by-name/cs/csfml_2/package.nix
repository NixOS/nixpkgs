{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sfml_2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "csfml";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "SFML";
    repo = "CSFML";
    tag = finalAttrs.version;
    hash = "sha256-ECt0ySDpYWF0zuDBSnQzDwUm4Xj4z1+XSC55D6yivac=";
  };

  # Fix incorrect path joining in cmake
  # https://github.com/NixOS/nixpkgs/issues/144170
  postPatch = ''
    substituteInPlace tools/pkg-config/csfml-*.pc.in \
      --replace-fail \
        'libdir=''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@' \
        "libdir=@CMAKE_INSTALL_FULL_LIBDIR@"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ sfml_2 ];
  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_MODULE_PATH" "${sfml_2}/share/SFML/cmake/Modules/")
  ];

  meta = {
    homepage = "https://www.sfml-dev.org/";
    description = "Simple and fast multimedia library";
    longDescription = ''
      SFML is a simple, fast, cross-platform and object-oriented multimedia API.
      It provides access to windowing, graphics, audio and network.
      It is written in C++, and has bindings for various languages such as C, .Net, Ruby, Python.
    '';
    license = lib.licenses.zlib;
    maintainers = [ lib.maintainers.jpdoyle ];
    platforms = lib.platforms.linux;
  };
})
