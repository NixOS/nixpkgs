{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, doxygen, glew
, xorg, ffmpeg_4, libjpeg, libpng, libtiff, eigen
, Carbon ? null, Cocoa ? null
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pangolin";

  version = "v0.6";

  src = fetchFromGitHub {
    owner = "stevenlovegrove";
    repo = "Pangolin";
    rev = finalAttrs.version;
    hash = "sha256-SPJh/mKHSaMH8tBKnW8JAbmJOMmqRqil8oLRI7tUcik=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    doxygen
  ];

  buildInputs = [
    glew
    xorg.libX11
    ffmpeg_4
    libjpeg
    libpng
    libtiff
    eigen
  ]
  ++ lib.optionals stdenv.isDarwin [ Carbon Cocoa ];

  # The tests use cmake's findPackage to find the installed version of
  # pangolin, which isn't what we want (or available).
  doCheck = false;
  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" false)
  ];

  patches = [
    ./cstdint.patch
  ];

  meta = {
    description = "A lightweight portable rapid development library for managing OpenGL display / interaction and abstracting video input";
    longDescription = ''
      Pangolin is a lightweight portable rapid development library for managing
      OpenGL display / interaction and abstracting video input. At its heart is
      a simple OpenGl viewport manager which can help to modularise 3D
      visualisation without adding to its complexity, and offers an advanced
      but intuitive 3D navigation handler. Pangolin also provides a mechanism
      for manipulating program variables through config files and ui
      integration, and has a flexible real-time plotter for visualising
      graphical data.
    '';
    homepage = "https://github.com/stevenlovegrove/Pangolin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ expipiplus1 locochoco ];
    platforms = lib.platforms.all;
  };
})

