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
  libXrandr,
  libXrender,
  udev,
  xcbutilimage,
  darwin,
  libXcursor,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sfml";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "SFML";
    repo = "SFML";
    rev = finalAttrs.version;
    hash = "sha256-R+ULgaKSPadcPNW4D2/jlxMKHc1L9e4FprgqLRuyZk4=";
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
      libXrandr
      libXrender
      xcbutilimage
      libXcursor
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        IOKit
        Foundation
        AppKit
        OpenAL
      ]
    );

  cmakeFlags = [
    "-DSFML_INSTALL_PKGCONFIG_FILES=yes"
    "-DSFML_MISC_INSTALL_PREFIX=share/SFML"
    "-DSFML_BUILD_FRAMEWORKS=no"
    "-DSFML_USE_SYSTEM_DEPS=yes"
  ];

  patches = [
    # Fix pkg-config
    # See https://github.com/SFML/SFML/issues/2815
    # Also, too much changes in CMakeLists.txt and changelog.md,
    # so we patchin cmake ourself
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/SFML/SFML/pull/2835.patch";
      hash = "sha256-kdOAXR9YPQllx64z9dgwCV+vy0cJvIsZZboZKFc4Q8Q=";
      excludes = [ "changelog.md" "CMakeLists.txt" ];
    })
    ./CMakeLists.txt-pkgconfig.patch
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
    maintainers = with lib.maintainers; [ drawbu astsmtl ];
    platforms = lib.platforms.unix;
  };
})
