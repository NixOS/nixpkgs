{
  autoconf,
  automake,
  cxxtest,
  desktopToDarwinBundle,
  fetchgit,
  fontconfig,
  gettext,
  glm,
  gnulib,
  help2man,
  intltool,
  lib,
  libtool,
  nix-update-script,
  pkg-config,
  SDL2,
  SDL2_gfx,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freedink";
  version = "109.6";

  src = fetchgit {
    url = "https://git.savannah.gnu.org/git/freedink.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D+/Reg0+K9J1WcOpe3xdnIv90Cl0GCmB/2M1XU/3eOg=";
  };

  passthru = {
    # Data rarely changes, so not covered by update-script
    updateScript = nix-update-script { };

    freedink_data = stdenv.mkDerivation (final: {
      pname = "freedink-data";
      version = "1.08.20190120";

      src = fetchgit {
        url = "https://git.savannah.gnu.org/git/freedink/freedink-data.git";
        tag = "v${final.version}";
        hash = "sha256-8/yKy/oAPQkvNNQPWYCaHREHly7vJE63956ky0KVYI0=";
      };

      postPatch = "substituteInPlace Makefile --replace-fail /usr/local $out";
    });
  };

  nativeBuildInputs = [
    autoconf
    automake
    cxxtest
    gettext
    gnulib
    help2man
    intltool
    libtool
    pkg-config
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs = [
    fontconfig
    glm
    SDL2
    SDL2_gfx
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  env.GNULIB_TOOL_IMPL = "sh";

  preConfigure = ''
    substituteInPlace configure.ac --replace-fail "AC_PREREQ(2.61)" "AC_PREREQ(2.64)"
    gnulib-tool --update --more-symlinks
    autoreconf -fi
  '';

  preBuild = ''
    substituteInPlace src/gfx_fonts.cpp \
      --replace-fail "char *familyname = TTF_FontFaceFamilyName(font);" \
                "const char *familyname = TTF_FontFaceFamilyName(font);" \
      --replace-fail "char *stylename = TTF_FontFaceStyleName(font);" \
                "const char *stylename = TTF_FontFaceStyleName(font);"

    substituteInPlace src/input.cpp \
      --replace-fail "SDL_SetHint(SDL_HINT_ANDROID_SEPARATE_MOUSE_AND_TOUCH, \"0\");" \
                "/* SDL_SetHint(SDL_HINT_ANDROID_SEPARATE_MOUSE_AND_TOUCH, \"0\"); */"

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
    ln -s ${finalAttrs.passthru.freedink_data}/share/dink "$out/share/"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Free, portable and enhanced version of the Dink Smallwood game engine";
    longDescription = ''
      GNU FreeDink is a new and portable version of the Dink Smallwood
      game engine, which runs the original game as well as its D-Mods,
      with close compatibility, under multiple platforms.
    '';
    homepage = "https://gnu.org/software/freedink/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      iedame
      philocalyst
    ];
    platforms = lib.platforms.all;
    mainProgram = "freedink";
  };
})
