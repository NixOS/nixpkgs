{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,

  # buildInputs
  flac,
  freetype,
  glew,
  libjpeg,
  libvorbis,
  openal,
  udev,
  libXi,
  libX11,
  libXcursor,
  libXrandr,
  libXrender,
  xcbutilimage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sfml";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "SFML";
    repo = "SFML";
    tag = finalAttrs.version;
    hash = "sha256-e6x/L2D3eT6F/DBLQDZ+j0XD5NL9RalWZA8kcm9lZ3g=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs =
    [
      flac
      freetype
      glew
      libjpeg
      libvorbis
      openal
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux udev
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      libX11
      libXi
      libXcursor
      libXrandr
      libXrender
      xcbutilimage
    ];

  cmakeFlags = [
    (lib.cmakeBool "SFML_INSTALL_PKGCONFIG_FILES" true)
    (lib.cmakeFeature "SFML_MISC_INSTALL_PREFIX" "share/SFML")
    (lib.cmakeBool "SFML_BUILD_FRAMEWORKS" false)
    (lib.cmakeBool "SFML_USE_SYSTEM_DEPS" true)
  ];

  meta = {
    description = "Simple and fast multimedia library";
    homepage = "https://www.sfml-dev.org/";
    changelog = "https://github.com/SFML/SFML/blob/${finalAttrs.version}/changelog.md";
    longDescription = ''
      SFML is a simple, fast, cross-platform and object-oriented multimedia API.
      It provides access to windowing, graphics, audio and network.
      It is written in C++, and has bindings for various languages such as C, .Net, Ruby, Python.
    '';
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.unix;
  };
})
