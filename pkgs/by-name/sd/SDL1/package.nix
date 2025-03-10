{ lib
, alsa-lib
, audiofile
, config
, darwin
, fetchFromGitHub
, fetchpatch
, libGL
, libGLU
, libICE
, libXext
, libXrandr
, libcap
, libiconv
, libpulseaudio
, pkg-config
, stdenv
, unstableGitUpdater

# passthru.tests
, blender
, directfb
, dosbox
, hheretic
, hhexen
, libvlc
, mednafen
, onscripter-en
, powermanga
, SDL_Pango
, SDL_gfx
, SDL_image
, SDL_mixer
, SDL_net
, SDL_sixel
, SDL_sound
, SDL_stretch
, SDL_ttf
, sfxr
, vlc

# Boolean flags
, alsaSupport ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAndroid
, libGLSupported ? lib.meta.availableOn stdenv.hostPlatform libGL
, openglSupport ? libGLSupported
, pulseaudioSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAndroid && lib.meta.availableOn stdenv.hostPlatform libpulseaudio
, x11Support ? !stdenv.hostPlatform.isCygwin && !stdenv.hostPlatform.isAndroid
}:

# NOTE: When editing this expression see if the same change applies to
# SDL2 expression too

let
  inherit (darwin.apple_sdk.frameworks) OpenGL CoreAudio CoreServices AudioUnit Kernel Cocoa GLUT;
  extraPropagatedBuildInputs = [ ]
    ++ lib.optionals x11Support [ libXext libICE libXrandr ]
    ++ lib.optionals (openglSupport && stdenv.hostPlatform.isLinux) [ libGL ]
    # libGLU doesn’t work with Android's SDL
    ++ lib.optionals (openglSupport && stdenv.hostPlatform.isLinux && (!stdenv.hostPlatform.isAndroid)) [ libGLU ]
    ++ lib.optionals (openglSupport && stdenv.hostPlatform.isDarwin) [ OpenGL GLUT ]
    ++ lib.optional alsaSupport alsa-lib
    ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional stdenv.hostPlatform.isDarwin Cocoa;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "SDL";
  # 1.2.15 was released in 2013, 1.2.16 is packed with fixes but not yet tagged
  version = "1.2.15-unstable-2025-03-02";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL-1.2";
    rev = "18bc4d1a1d27b0cf5b06be9322c65ca88282b1ee";
    hash = "sha256-1KcP8wpzKUJAO2KjVqRFcACgaCGxdKCNF9BD2G2+aXA=";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev"; # sdl-config

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optional stdenv.hostPlatform.isLinux libcap;

  propagatedBuildInputs = [ libiconv ] ++ extraPropagatedBuildInputs;

  buildInputs =
    [ ]
    ++ lib.optionals (!stdenv.hostPlatform.isMinGW && alsaSupport) [ audiofile ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ AudioUnit CoreAudio CoreServices Kernel OpenGL ];

  configureFlags = [
    "--disable-oss"
    "--disable-video-x11-xme"
    "--enable-rpath"
  # Building without this fails on Darwin with
  #
  #   ./src/video/x11/SDL_x11sym.h:168:17: error: conflicting types for '_XData32'
  #   SDL_X11_SYM(int,_XData32,(Display *dpy,register long *data,unsigned len),(dpy,data,len),return)
  #
  # Please try revert the change that introduced this comment when updating SDL.
  ] ++ lib.optional stdenv.hostPlatform.isDarwin "--disable-x11-shared"
    ++ lib.optional (!x11Support) "--without-x"
    ++ lib.optional alsaSupport "--with-alsa-prefix=${alsa-lib.out}/lib"
    ++ lib.optional stdenv.hostPlatform.isMusl "CFLAGS=-DICONV_INBUF_NONCONST";

  patches = [
    ./find-headers.patch

    # Workaround X11 bug to allow changing gamma
    # Ticket: https://bugs.freedesktop.org/show_bug.cgi?id=27222
    (fetchpatch {
      name = "SDL_SetGamma.patch";
      url = "https://src.fedoraproject.org/rpms/SDL/raw/7a07323e5cec08bea6f390526f86a1ce5341596d/f/SDL-1.2.15-x11-Bypass-SetGammaRamp-when-changing-gamma.patch";
      hash = "sha256-m7ZQ5GnfGlMkKJkrBSB3GrLz8MT6njgI9jROJAbRonQ=";
    })
  ];

  enableParallelBuilding = true;

  postInstall = ''
    moveToOutput share/aclocal "$dev"
  '';

  # See the same place in the expression for SDL2
  postFixup = let
    rpath = lib.makeLibraryPath extraPropagatedBuildInputs;
  in ''
    for lib in $out/lib/*.so* ; do
      if [[ -L "$lib" ]]; then
        patchelf --set-rpath "$(patchelf --print-rpath $lib):${rpath}" "$lib"
      fi
    done
  '';

  setupHook = ./setup-hook.sh;

  passthru = {
    inherit openglSupport;

    tests = lib.filterAttrs (key: value: value.meta.available) {
      inherit
        blender
        directfb
        hheretic
        hhexen
        mednafen
        onscripter-en
        powermanga
        SDL_Pango
        SDL_gfx
        SDL_image
        SDL_mixer
        SDL_net
        SDL_sound
        SDL_ttf
        sfxr
        vlc
        ;
    };

    updateScript = unstableGitUpdater {
      tagPrefix = "release-";
    };
  };

  meta = {
    homepage = "http://www.libsdl.org/";
    description = "Cross-platform multimedia library";
    license = lib.licenses.lgpl21;
    mainProgram = "sdl-config";
    changelog = "https://github.com/libsdl-org/SDL-1.2/blob/${finalAttrs.src.rev}/WhatsNew";
    maintainers = lib.teams.sdl.members ++ (with lib.maintainers; [ lovek323 ]);
    platforms = lib.platforms.unix;
  };
})
