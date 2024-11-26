{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  IOKit,
  Foundation,
  AppKit,
  OpenAL,
}:

stdenv.mkDerivation rec {
  pname = "sfml";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "SFML";
    repo = "SFML";
    rev = version;
    sha256 = "sha256-Xt2Ct4vV459AsSvJxQfwMsNs6iA5y3epT95pLWJGeSk=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/macports/macports-ports/raw/4df1fc235a708ff28200ffc0a39120974ed4b6e1/multimedia/sfml/files/patch-apple-silicon.diff";
      extraPrefix = "";
      sha256 = "sha256-9dNawJaYtkugR+2NvhQOhgsf6w9ZXHkBgsDRh8yAJc0=";
    })
    (fetchpatch {
      url = "https://github.com/SFML/SFML/commit/bf92efe9a4035fee0258386173d53556aa196e49.patch";
      hash = "sha256-1htwPfpn7Z6s/3b+/i1tQ+btjr/tWv5m6IyDVMBNqQA=";
    })
  ];

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
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      IOKit
      Foundation
      AppKit
      OpenAL
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
