{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  doxygen,
  libglut,
  freetype,
  libGL,
  libGLU,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "ftgl";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "frankheckenbach";
    repo = "ftgl";
    rev = "v${version}";
    hash = "sha256-6TDNGoMeBLnucmHRgEDIVWcjlJb7N0sTluqBwRMMWn4=";
  };

  # GL_DYLIB is hardcoded to an impure path
  # /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGL.dylib
  # and breaks build on recent macOS versions
  postPatch = ''
    substituteInPlace m4/gl.m4 \
      --replace ' -dylib_file $GL_DYLIB: $GL_DYLIB' ""
  '';

  patches = [
    ./fix-warnings.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    doxygen
    pkg-config
  ];
  buildInputs = [
    freetype
    libGL
    libGLU
    libglut
  ];

  postInstall = ''
    install -Dm644 src/FTSize.h src/FTFace.h -t $out/include/FTGL
  '';

  meta = with lib; {
    homepage = "https://github.com/frankheckenbach/ftgl";
    description = "Font rendering library for OpenGL applications";
    longDescription = ''
      FTGL is a free cross-platform Open Source C++ library that uses Freetype2
      to simplify rendering fonts in OpenGL applications. FTGL supports bitmaps,
      pixmaps, texture maps, outlines, polygon mesh, and extruded polygon
      rendering modes.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
