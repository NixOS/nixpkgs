{
  lib,
  alsa-lib,
  audiofile,
  apple-sdk,
  dbus,
  fetchFromGitHub,
  ibus,
  libGL,
  libICE,
  libX11,
  libXScrnSaver,
  libXcursor,
  libXext,
  libXi,
  libXinerama,
  libXrandr,
  libXxf86vm,
  libdecor,
  libdrm,
  libiconv,
  libpulseaudio,
  libxkbcommon,
  mesa,
  nix-update-script,
  pipewire, # NOTE: must be built with SDL2 without pipewire support
  pkg-config,
  stdenv,
  udev,
  wayland,
  wayland-protocols,
  wayland-scanner,
  xorgproto,
  # Boolean flags
  alsaSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid,
  dbusSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid,
  drmSupport ? false,
  enableSdltest ? stdenv.hostPlatform.isDarwin,
  ibusSupport ? false,
  libGLSupported ? lib.elem stdenv.hostPlatform.system mesa.meta.platforms,
  libdecorSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid,
  openglSupport ? libGLSupported,
  pipewireSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid,
  pulseaudioSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid,
  udevSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid,
  waylandSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid,
  withStatic ? stdenv.hostPlatform.isMinGW,
  x11Support ? !stdenv.hostPlatform.isWindows && !stdenv.hostPlatform.isAndroid,
  # passthru.tests
  SDL2_gfx,
  SDL2_image,
  SDL2_mixer,
  SDL2_net,
  SDL2_sound,
  SDL2_ttf,
  guile-sdl2,
  jazz2,
  python3Packages,
  testers,
}:

# NOTE: When editing this expression see if the same change applies to
# SDL expression too
let
  dlopenPropagatedBuildInputs =
    # Propagated for #include <GLES/gl.h> in SDL_opengles.h.
    lib.optionals (openglSupport && !stdenv.isDarwin) [ libGL ]
    # Propagated for #include <X11/Xlib.h> and <X11/Xatom.h> in SDL_syswm.h.
    ++ lib.optionals x11Support [ libX11 ];

  dlopenBuildInputs =
    lib.optionals alsaSupport [
      alsa-lib
      audiofile
    ]
    ++ lib.optionals dbusSupport [ dbus ]
    ++ lib.optionals libdecorSupport [ libdecor ]
    ++ lib.optionals pipewireSupport [ pipewire ]
    ++ lib.optionals pulseaudioSupport [ libpulseaudio ]
    ++ lib.optionals udevSupport [ udev ]
    ++ lib.optionals waylandSupport [
      wayland
      libxkbcommon
    ]
    ++ lib.optionals x11Support [
      libICE
      libXi
      libXScrnSaver
      libXcursor
      libXinerama
      libXext
      libXrandr
      libXxf86vm
    ]
    ++ lib.optionals drmSupport [
      libdrm
      mesa
    ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "SDL2";
  version = "2.30.9";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-6KfvZjs4UkaakEng3KAKly2gCqrOhS7skxJQjKAM6HQ=";
  };

  outputs = [
    "out"
    "dev"
  ];

  outputBin = "dev"; # sdl-config

  patches = [
    # `sdl2-config --cflags` from Nixpkgs returns include path to just SDL2. On
    # a normal distro this is enough for includes from all SDL2* packages to
    # work, but on NixOS they're spread across different paths.
    # This patch + the setup-hook will ensure that `sdl2-config --cflags` works correctly.
    ./0000-find-headers.patch
  ];

  postPatch = ''
    # Fix running wayland-scanner for the build platform when cross-compiling.
    # See comment here: https://github.com/libsdl-org/SDL/issues/4860#issuecomment-1119003545
    substituteInPlace configure \
      --replace '$(WAYLAND_SCANNER)' 'wayland-scanner'
  '';

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs =
    [ pkg-config ]
    ++ lib.optionals waylandSupport [
      wayland
      wayland-scanner
    ];

  propagatedBuildInputs = lib.optionals x11Support [ xorgproto ] ++ dlopenPropagatedBuildInputs;

  buildInputs =
    [ libiconv ]
    ++ dlopenBuildInputs
    ++ lib.optionals ibusSupport [ ibus ]
    ++ lib.optionals waylandSupport [ wayland-protocols ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk
    ];

  configureFlags = [
    (lib.enableFeature false "oss")
    (lib.withFeature x11Support "x")
    (lib.withFeatureAs alsaSupport "alsa-prefix" "${lib.getLib alsa-lib}/lib")
    (lib.enableFeature (!stdenv.hostPlatform.isWindows) "video-opengles")
    (lib.enableFeature enableSdltest "sdltest")
  ];

  dontDisableStatic = withStatic;

  strictDeps = true;

  enableParallelBuilding = true;

  # We remove libtool .la files when static libs are requested,
  # because they make the builds of downstream libs like `SDL_tff`
  # fail with `cannot find -lXext, `-lXcursor` etc. linker errors
  # because the `.la` files are not pruned if static libs exist
  # (see https://github.com/NixOS/nixpkgs/commit/fd97db43bcb05e37f6bb77f363f1e1e239d9de53)
  # and they also don't carry the necessary `-L` paths of their
  # X11 dependencies.
  # For static linking, it is better to rely on `pkg-config` `.pc`
  # files.
  postInstall =
    (if withStatic then ''rm $out/lib/*.la'' else ''rm $out/lib/*.a'')
    + "\n"
    + ''moveToOutput bin/sdl2-config "$dev"'';

  # SDL is weird in that instead of just dynamically linking with
  # libraries when you `--enable-*` (or when `configure` finds) them
  # it `dlopen`s them at runtime. In principle, this means it can
  # ignore any missing optional dependencies like alsa, pulseaudio,
  # some x11 libs, wayland, etc if they are missing on the system
  # and/or work with wide array of versions of said libraries. In
  # nixpkgs, however, we don't need any of that. Moreover, since we
  # don't have a global ld-cache we have to stuff all the propagated
  # libraries into rpath by hand or else some applications that use
  # SDL API that requires said libraries will fail to start.
  #
  # You can grep SDL sources with `grep -rE 'SDL_(NAME|.*_SYM)'` to
  # list the symbols used in this way.
  postFixup =
    let
      rpath = lib.makeLibraryPath (dlopenPropagatedBuildInputs ++ dlopenBuildInputs);
    in
    lib.optionalString (stdenv.hostPlatform.extensions.sharedLibrary == ".so") ''
      for lib in $out/lib/*.so* ; do
        if ! [[ -L "$lib" ]]; then
          patchelf --set-rpath "$(patchelf --print-rpath $lib):${rpath}" "$lib"
        fi
      done
    '';

  setupHook = ./setup-hook.sh;

  passthru = {
    inherit openglSupport;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "release-(.*)"
      ];
    };
    tests = {
      pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
      inherit
        SDL2_gfx
        SDL2_image
        SDL2_mixer
        SDL2_net
        SDL2_sound
        SDL2_ttf
        guile-sdl2
        jazz2
        ;
      inherit (python3Packages) pygame pygame-ce pygame-sdl2;
    };
  };

  meta = {
    homepage = "http://www.libsdl.org/";
    changelog = "https://github.com/libsdl-org/SDL/releases/tag/release-${finalAttrs.version}";
    description = "Cross-platform multimedia library";
    license = lib.licenses.zlib;
    mainProgram = "sdl2-config";
    maintainers = lib.teams.sdl.members;
    pkgConfigModules = [ "sdl2" ];
    platforms = lib.platforms.all;
  };
})
