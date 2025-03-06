{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libX11,
  freetype,
  libjpeg,
  openal,
  flac,
  libvorbis,
  glew,
  libXcursor,
  libXrandr,
  libXrender,
  udev,
  xcbutilimage,
}:

stdenv.mkDerivation rec {
  pname = "sfml";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "SFML";
    repo = "SFML";
    rev = version;
    hash = "sha256-m8FVXM56qjuRKRmkcEcRI8v6IpaJxskoUQ+sNsR1EhM=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs =
    [
      freetype
      libjpeg
      openal
      flac
      libvorbis
      glew
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux udev
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      libX11
      libXcursor
      libXrandr
      libXrender
      xcbutilimage
    ];

  cmakeFlags = [
    "-DSFML_INSTALL_PKGCONFIG_FILES=yes"
    "-DSFML_MISC_INSTALL_PREFIX=share/SFML"
    "-DSFML_BUILD_FRAMEWORKS=no"
    "-DSFML_USE_SYSTEM_DEPS=yes"
  ];

  meta = with lib; {
    homepage = "https://www.sfml-dev.org/";
    description = "Simple and fast multimedia library";
    longDescription = ''
      SFML is a simple, fast, cross-platform and object-oriented multimedia API.
      It provides access to windowing, graphics, audio and network.
      It is written in C++, and has bindings for various languages such as C, .Net, Ruby, Python.
    '';
    license = licenses.zlib;
    maintainers = [ maintainers.astsmtl ];
    platforms = platforms.unix;
  };
}
