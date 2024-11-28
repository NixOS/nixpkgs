{ lib
, alsa-lib
, audiofile
, config
, darwin
, fetchFromGitHub
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
  version = "1.2.15-unstable-2024-10-27";

  # 1.2.15 was released in 2013, 1.2.16 is not yet tagged
  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL-1.2";
    rev = "0237f339e6bec39c56e1364787fabdb0245d478f";
    hash = "sha256-SotMz2BATJn5dpD8l3bINH639Q1Ux0AGRWn+JQeiRFg=";
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

    updateScript = unstableGitUpdater {
      tagPrefix = "release-";
    };
  };

  meta = {
    homepage = "http://www.libsdl.org/";
    changelog   = "https://github.com/libsdl-org/SDL-1.2/blob/${finalAttrs.src.rev}/WhatsNew";
    description = "Cross-platform multimedia library";
    license = lib.licenses.lgpl21;
    mainProgram = "sdl-config";
    maintainers = lib.teams.sdl.members ++ (with lib.maintainers; [ lovek323 ]);
    platforms = lib.platforms.unix;
  };
})
