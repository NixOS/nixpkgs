{ lib
, alsa-lib
, audiofile
, config
, darwin
, fetchpatch
, fetchurl
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
# Boolean flags
, alsaSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid
, libGLSupported ? lib.meta.availableOn stdenv.hostPlatform libGL
, openglSupport ? libGLSupported
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux && !stdenv.hostPlatform.isAndroid && lib.meta.availableOn stdenv.hostPlatform libpulseaudio
, x11Support ? !stdenv.isCygwin && !stdenv.hostPlatform.isAndroid
}:

# NOTE: When editing this expression see if the same change applies to
# SDL2 expression too

let
  inherit (darwin.apple_sdk.frameworks) OpenGL CoreAudio CoreServices AudioUnit Kernel Cocoa GLUT;
  extraPropagatedBuildInputs = [ ]
    ++ lib.optionals x11Support [ libXext libICE libXrandr ]
    ++ lib.optionals (openglSupport && stdenv.isLinux) [ libGL ]
    # libGLU doesn’t work with Android's SDL
    ++ lib.optionals (openglSupport && stdenv.isLinux && (!stdenv.hostPlatform.isAndroid)) [ libGLU ]
    ++ lib.optionals (openglSupport && stdenv.isDarwin) [ OpenGL GLUT ]
    ++ lib.optional alsaSupport alsa-lib
    ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional stdenv.isDarwin Cocoa;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "SDL";
  version = "1.2.15";

  src = fetchurl {
    url = "https://www.libsdl.org/release/SDL-${finalAttrs.version}.tar.gz";
    hash = "sha256-1tMWp5Pl40gVXw3ZO5eXmJM/uYqh7evMEIgp1kdKrQA=";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev"; # sdl-config

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optional stdenv.isLinux libcap;

  propagatedBuildInputs = [ libiconv ] ++ extraPropagatedBuildInputs;

  buildInputs =
    [ ]
    ++ lib.optionals (!stdenv.hostPlatform.isMinGW && alsaSupport) [ audiofile ]
    ++ lib.optionals stdenv.isDarwin [ AudioUnit CoreAudio CoreServices Kernel OpenGL ];

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
  ] ++ lib.optional stdenv.isDarwin "--disable-x11-shared"
    ++ lib.optional (!x11Support) "--without-x"
    ++ lib.optional alsaSupport "--with-alsa-prefix=${alsa-lib.out}/lib"
    ++ lib.optional stdenv.hostPlatform.isMusl "CFLAGS=-DICONV_INBUF_NONCONST";

  patches = [
    ./find-headers.patch

    # Fix window resizing issues, e.g. for xmonad
    # Ticket: http://bugzilla.libsdl.org/show_bug.cgi?id=1430
    (fetchpatch {
      name = "fix_window_resizing.diff";
      url = "https://bugs.debian.org/cgi-bin/bugreport.cgi?msg=10;filename=fix_window_resizing.diff;att=2;bug=665779";
      hash = "sha256-hj3ykyOKeDh6uPDlvwNHSowQxmR+mfhvCnHvcdhXZfw=";
    })
    # Fix drops of keyboard events for SDL_EnableUNICODE
    (fetchpatch {
      url = "https://github.com/libsdl-org/SDL-1.2/commit/0332e2bb18dc68d6892c3b653b2547afe323854b.patch";
      hash = "sha256-5V6K0oTN56RRi48XLPQsjgLzt0a6GsjajDrda3ZEhTw=";
    })
    # Ignore insane joystick axis events
    (fetchpatch {
      url = "https://github.com/libsdl-org/SDL-1.2/commit/ab99cc82b0a898ad528d46fa128b649a220a94f4.patch";
      hash = "sha256-8CvKHvkmidm4tFCWYhxE059hN3gwOKz6nKs5rvQ4ZKw=";
    })
    # https://bugzilla.libsdl.org/show_bug.cgi?id=1769
    (fetchpatch {
      url = "https://github.com/libsdl-org/SDL-1.2/commit/5d79977ec7a6b58afa6e4817035aaaba186f7e9f.patch";
      hash = "sha256-t+60bC4gLFbslXm1n9nimiFrho2DnxdWdKr4H9Yp/sw=";
    })
    # Workaround X11 bug to allow changing gamma
    # Ticket: https://bugs.freedesktop.org/show_bug.cgi?id=27222
    (fetchpatch {
      name = "SDL_SetGamma.patch";
      url = "https://src.fedoraproject.org/rpms/SDL/raw/7a07323e5cec08bea6f390526f86a1ce5341596d/f/SDL-1.2.15-x11-Bypass-SetGammaRamp-when-changing-gamma.patch";
      hash = "sha256-m7ZQ5GnfGlMkKJkrBSB3GrLz8MT6njgI9jROJAbRonQ=";
    })
    # Fix a build failure on OS X Mavericks
    # Ticket: https://bugzilla.libsdl.org/show_bug.cgi?id=2085
    (fetchpatch {
      url = "https://github.com/libsdl-org/SDL-1.2/commit/19039324be71738d8990e91b9ba341b2ea068445.patch";
      hash = "sha256-DCWZo0LzHJoWUr/5vL5pKIEmmz3pvr4TO6Ip8WykfDI=";
    })
    (fetchpatch {
      url = "https://github.com/libsdl-org/SDL-1.2/commit/7933032ad4d57c24f2230db29f67eb7d21bb5654.patch";
      hash = "sha256-Knq+ceL6y/zKcfJayC2gy+DKnoa8DLslBNl3laMzwa8=";
    })
    (fetchpatch {
      name = "CVE-2022-34568.patch";
      url = "https://github.com/libsdl-org/SDL-1.2/commit/d7e00208738a0bc6af302723fe64908ac35b777b.patch";
      hash = "sha256-fuxXsqZW94/C8CKu9LakppCU4zHupj66O2MngQ4BO9o=";
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

  passthru = { inherit openglSupport; };

  meta = {
    homepage = "http://www.libsdl.org/";
    description = "Cross-platform multimedia library";
    license = lib.licenses.lgpl21;
    mainProgram = "sdl-config";
    maintainers = lib.teams.sdl.members ++ (with lib.maintainers; [ lovek323 ]);
    platforms = lib.platforms.unix;
  };
})
