{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  SDL,
  autoconf,
  automake,
  libtool,
  gtk2,
  m4,
  pkg-config,
  libGLU,
  libGL,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "smpeg";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "icculus";
    repo = "smpeg";
    rev = "release_${builtins.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-nq/i7cFGpJXIuTwN/ScLMX7FN8NMdgdsRM9xOD3uycs=";
  };

  patches = [
    ./format.patch
    ./gcc6.patch
    ./libx11.patch
    ./gtk.patch
    # These patches remove use of the `register` storage class specifier,
    # allowing smpeg to build with clang 16, which defaults to C++17.
    (fetchpatch {
      url = "https://github.com/icculus/smpeg/commit/cc114ba0dd8644c0d6205bbce2384781daeff44b.patch";
      hash = "sha256-GxSD82j05pw0r2SxmPYAe/BXX4iUc+iHWhB9Ap4GzfA=";
    })
    (fetchpatch {
      url = "https://github.com/icculus/smpeg/commit/b369feca5bf99d6cff50d8eb316395ef48acf24f.patch";
      hash = "sha256-U+a6dbc5cm249KlUcf4vi79yUiT4hgEvMv522K4PqUc=";
    })
  ];

  postPatch = ''
    substituteInPlace video/gdith.cpp \
      --replace 'register int' 'int' \
      --replace 'register Uint16' 'Uint16'
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    m4
    pkg-config
    makeWrapper
  ];

  buildInputs =
    [ SDL ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      gtk2
      libGLU
      libGL
    ];

  outputs = [
    "out"
    "dev"
  ];

  preConfigure = ''
    touch NEWS AUTHORS ChangeLog
    sh autogen.sh
  '';

  postInstall = ''
    sed -i -e 's,"SDL.h",<SDL/SDL.h>,' \
    -e 's,"SDL_mutex.h",<SDL/SDL_mutex.h>,' \
    -e 's,"SDL_audio.h",<SDL/SDL_audio.h>,' \
    -e 's,"SDL_thread.h",<SDL/SDL_thread.h>,' \
    -e 's,"SDL_types.h",<SDL/SDL_types.h>,' \
      $dev/include/smpeg/*.h

    moveToOutput bin/smpeg-config "$dev"

    wrapProgram $dev/bin/smpeg-config \
      --prefix PATH ":" "${pkg-config}/bin" \
      --prefix PKG_CONFIG_PATH ":" "${lib.getDev SDL}/lib/pkgconfig"
  '';

  NIX_LDFLAGS = "-lX11";

  meta = {
    homepage = "http://icculus.org/smpeg/";
    description = "MPEG decoding library";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
