{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sfml,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "csfml";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "SFML";
    repo = "CSFML";
    tag = finalAttrs.version;
    hash = "sha256-8CRS+dV/hVQNTmgkxyFKcyTj/HWRks5bie4n6N/RWYM=";
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
  buildInputs = [ sfml ];
  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_MODULE_PATH" "${sfml}/share/SFML/cmake/Modules/")
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
