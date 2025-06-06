{
  lib,
  stdenv,
  config,
  alsa-lib,
  apple-sdk_11,
  cmake,
  darwinMinVersionHook,
  dbus,
  fetchFromGitHub,
  ibusMinimal,
  installShellFiles,
  libGL,
  libayatana-appindicator,
  libdecor,
  libdrm,
  libjack2,
  libpulseaudio,
  libusb1,
  libxkbcommon,
  libgbm,
  ninja,
  nix-update-script,
  nixosTests,
  pipewire,
  sndio,
  systemdLibs,
  testers,
  validatePkgConfig,
  vulkan-headers,
  vulkan-loader,
  wayland,
  wayland-scanner,
  xorg,
  zenity,
  alsaSupport ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAndroid,
  dbusSupport ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAndroid,
  drmSupport ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAndroid,
  ibusSupport ? stdenv.hostPlatform.isUnix && !stdenv.hostPlatform.isDarwin,
  jackSupport ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAndroid,
  libdecorSupport ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAndroid,
  openglSupport ? lib.meta.availableOn stdenv.hostPlatform libGL,
  pipewireSupport ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAndroid,
  pulseaudioSupport ?
    config.pulseaudio or stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAndroid,
  libudevSupport ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAndroid,
  sndioSupport ? false,
  testSupport ? true,
  traySupport ? true,
  waylandSupport ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAndroid,
  x11Support ? !stdenv.hostPlatform.isAndroid && !stdenv.hostPlatform.isWindows,
}:

assert lib.assertMsg (
  waylandSupport -> openglSupport
) "SDL3 requires OpenGL support to enable Wayland";
assert lib.assertMsg (ibusSupport -> dbusSupport) "SDL3 requires dbus support to enable ibus";

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl3";
  version = "3.2.20";

  outputs =
    [
      "lib"
      "dev"
      "out"
    ]
    ++ lib.optionals testSupport [
      "installedTests"
    ];

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-ESYjTN2prkAeHcTYurZaWeM3RgEKtwCZrt9gSMcOAe0=";
  };

  postPatch =
    # Tests timeout on Darwin
    # `testtray` loads assets from a relative path, which we are patching to be absolute
    lib.optionalString testSupport ''
      substituteInPlace test/CMakeLists.txt \
        --replace-fail 'set(noninteractive_timeout 10)' 'set(noninteractive_timeout 30)'

      substituteInPlace test/testtray.c \
        --replace-warn '../test/' '${placeholder "installedTests"}/share/assets/'
    ''
    + lib.optionalString waylandSupport ''
      substituteInPlace src/video/wayland/SDL_waylandmessagebox.c \
        --replace-fail '"zenity"' '"${lib.getExe zenity}"'
      substituteInPlace src/dialog/unix/SDL_zenitydialog.c \
        --replace-fail '"zenity"' '"${lib.getExe zenity}"'
    '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    validatePkgConfig
  ]
  ++ lib.optional waylandSupport wayland-scanner;

  buildInputs =
    finalAttrs.dlopenBuildInputs
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # error: 'MTLPixelFormatASTC_4x4_LDR' is unavailable: not available on macOS
      (darwinMinVersionHook "11.0")

      apple-sdk_11
    ]
    ++ lib.optionals ibusSupport [
      # sdl3 only uses some constants of the ibus headers
      # it never actually loads the library
      # thus, it also does not have to care about gtk integration,
      # so using ibusMinimal avoids an unnecessarily large closure here.
      ibusMinimal
    ]
    ++ lib.optional waylandSupport zenity;

  dlopenBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      libusb1
    ]
    ++ lib.optional (
      stdenv.hostPlatform.isUnix && !stdenv.hostPlatform.isDarwin && traySupport
    ) libayatana-appindicator
    ++ lib.optional alsaSupport alsa-lib
    ++ lib.optional dbusSupport dbus
    ++ lib.optionals drmSupport [
      libdrm
      libgbm
    ]
    ++ lib.optional jackSupport libjack2
    ++ lib.optional libdecorSupport libdecor
    ++ lib.optional libudevSupport systemdLibs
    ++ lib.optional openglSupport libGL
    ++ lib.optional pipewireSupport pipewire
    ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional sndioSupport sndio
    ++ lib.optionals waylandSupport [
      libxkbcommon
      wayland
    ]
    ++ lib.optionals x11Support [
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcursor
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
    ]
    ++ [
      vulkan-headers
      vulkan-loader
    ]
    ++ lib.optional (openglSupport && !stdenv.hostPlatform.isDarwin) libGL
    ++ lib.optional x11Support xorg.libX11;

  cmakeFlags = [
    (lib.cmakeBool "SDL_ALSA" alsaSupport)
    (lib.cmakeBool "SDL_DBUS" dbusSupport)
    (lib.cmakeBool "SDL_IBUS" ibusSupport)
    (lib.cmakeBool "SDL_JACK" jackSupport)
    (lib.cmakeBool "SDL_KMSDRM" drmSupport)
    (lib.cmakeBool "SDL_LIBUDEV" libudevSupport)
    (lib.cmakeBool "SDL_OPENGL" openglSupport)
    (lib.cmakeBool "SDL_PIPEWIRE" pipewireSupport)
    (lib.cmakeBool "SDL_PULSEAUDIO" pulseaudioSupport)
    (lib.cmakeBool "SDL_SNDIO" sndioSupport)
    (lib.cmakeBool "SDL_TEST_LIBRARY" testSupport)
    (lib.cmakeBool "SDL_TRAY_DUMMY" (!traySupport))
    (lib.cmakeBool "SDL_WAYLAND" waylandSupport)
    (lib.cmakeBool "SDL_WAYLAND_LIBDECOR" libdecorSupport)
    (lib.cmakeBool "SDL_X11" x11Support)

    (lib.cmakeBool "SDL_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "SDL_INSTALL_TESTS" testSupport)
  ];

  doCheck = testSupport && stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # See comment below. We actually *do* need these RPATH entries
  dontPatchELF = true;

  env = {
    # Many dependencies are not directly linked to, but dlopen()'d at runtime. Adding them to the RPATH
    # helps them be found
    NIX_LDFLAGS = lib.optionalString (
      stdenv.hostPlatform.hasSharedLibraries && stdenv.hostPlatform.extensions.sharedLibrary == ".so"
    ) "-rpath ${lib.makeLibraryPath (finalAttrs.dlopenBuildInputs)}";
  };

  postInstall = lib.optionalString testSupport ''
    moveToOutput "share/installed-tests" "$installedTests"
    moveToOutput "libexec/installed-tests" "$installedTests"
    install -Dm 444 -t $installedTests/share/assets test/*.bmp
  '';

  passthru = {
    # Building this in its own derivation to make sure the rpath hack above propagate to users
    debug-text-example = stdenv.mkDerivation (finalAttrs': {
      pname = "sdl3-debug-text-example";
      inherit (finalAttrs) version src;

      sourceRoot = "${finalAttrs'.src.name}/examples/renderer/18-debug-text";

      nativeBuildInputs = [
        installShellFiles
      ];

      buildInputs = [ finalAttrs.finalPackage ];

      postBuild = ''
        $CC -lSDL3 -o debug-text{,.c}
      '';

      postInstall = ''
        installBin debug-text
      '';

      meta = {
        inherit (finalAttrs.meta) maintainers platforms;
        mainProgram = "debug-text";
      };
    });

    tests = {
      pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
      inherit (finalAttrs.passthru) debug-text-example;
    }
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      nixosTest = nixosTests.sdl3;
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "release-(3\\..*)"
      ];
    };
  };

  meta = {
    description = "Cross-platform development library";
    homepage = "https://libsdl.org";
    changelog = "https://github.com/libsdl-org/SDL/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ getchoo ];
    teams = [ lib.teams.sdl ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    pkgConfigModules = [ "sdl3" ];
  };
})
