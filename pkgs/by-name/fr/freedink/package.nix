{
  cxxtest,
  fetchurl,
  fontconfig,
  glm,
  help2man,
  intltool,
  lib,
  libzip,
  pkg-config,
  SDL2,
  SDL2_gfx,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  stdenv,
  zip,
  zlib,
}:

let

  freedink_data = stdenv.mkDerivation (finalAttrs: {
    pname = "freedink-data";
    version = "1.08.20190120";

    src = fetchurl {
      url = "mirror://gnu/freedink/freedink-data-${finalAttrs.version}.tar.gz";
      hash = "sha256-cV9EdzsFtzqeybYrDhUvPygb4aFRL7qqOGF22pTP+50=";
    };

    prePatch = "substituteInPlace Makefile --replace-fail /usr/local $out";
  });

in

stdenv.mkDerivation (finalAttrs: {
  pname = "freedink";
  version = "109.6";

  src = fetchurl {
    url = "mirror://gnu/freedink/freedink-${finalAttrs.version}.tar.gz";
    hash = "sha256-Xgs1rI9G17uH5lbv1fnHwqwabFGakI/FtYHlJleYEAI=";
  };

  nativeBuildInputs = [
    cxxtest
    help2man
    intltool
    pkg-config
  ];

  buildInputs = [
    fontconfig
    glm
    libzip
    SDL2
    SDL2_mixer
    SDL2_image
    SDL2_ttf
    SDL2_gfx
    zip
    zlib
  ];

  preBuild = ''
        # Fix SDL2_ttf constness error in gfx_fonts.cpp
        substituteInPlace src/gfx_fonts.cpp \
          --replace-fail "char *familyname = TTF_FontFaceFamilyName(font);" \
                    "const char *familyname = TTF_FontFaceFamilyName(font);"
        substituteInPlace src/gfx_fonts.cpp \
          --replace-fail "char *stylename = TTF_FontFaceStyleName(font);" \
                    "const char *stylename = TTF_FontFaceStyleName(font);"

        # Fix missing SDL hint macro error in input.cpp
        substituteInPlace src/input.cpp \
          --replace-fail "SDL_SetHint(SDL_HINT_ANDROID_SEPARATE_MOUSE_AND_TOUCH, \"0\");" \
                    "/* SDL_SetHint(SDL_HINT_ANDROID_SEPARATE_MOUSE_AND_TOUCH, \"0\"); */"

        # Fix config.h errors in some platforms
        substituteInPlace src/ImageLoader.cpp \
          --replace-fail '#include "ImageLoader.h"' '#include "../config.h"
    #include "ImageLoader.h"'

        substituteInPlace src/IOGfxGLFuncs.cpp \
          --replace-fail '#include "IOGfxGLFuncs.h"' '#include "../config.h"
    #include "IOGfxGLFuncs.h"'

        substituteInPlace src/IOGfxSurface.cpp \
          --replace-fail '#include "IOGfxSurface.h"' '#include "../config.h"
    #include "IOGfxSurface.h"'

        substituteInPlace src/IOGfxSurfaceSW.cpp \
          --replace-fail '#include "IOGfxSurfaceSW.h"' '#include "../config.h"
    #include "IOGfxSurfaceSW.h"'

        substituteInPlace src/IOGfxPrimitivesSW.cpp \
          --replace-fail '#include "SDL.h"' '#include "../config.h"
    #include "SDL.h"'

        substituteInPlace src/dinkc_console_renderer.cpp \
          --replace-fail '#include "dinkc_console_renderer.h"' '#include "../config.h"
    #include "dinkc_console_renderer.h"'
  '';

  postInstall = ''
    mkdir -p "$out/share/"
    ln -s ${freedink_data}/share/dink "$out/share/"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Free, portable and enhanced version of the Dink Smallwood game engine";
    longDescription = ''
      GNU FreeDink is a new and portable version of the Dink Smallwood
      game engine, which runs the original game as well as its D-Mods,
      with close compatibility, under multiple platforms.
    '';
    homepage = "https://gnu.org/software/freedink/"; # Formerly http://www.freedink.org
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "freedink";
  };
})
