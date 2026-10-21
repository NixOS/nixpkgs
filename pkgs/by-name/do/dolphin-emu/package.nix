{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

  # nativeBuildInputs
  cmake,
  pkg-config,
  qt6,
  wrapGAppsHook3,
  # darwin-only
  re-plistbuddy,

  # buildInputs
  bzip2,
  cubeb,
  curl,
  enet,
  ffmpeg,
  fmt,
  glslang,
  gtest,
  hidapi,
  libxdmcp,
  libpulseaudio,
  libspng,
  libusb1,
  lz4,
  lzo,
  miniupnpc,
  minizip-ng,
  openal,
  pugixml,
  sdl3,
  sfml,
  xxhash,
  xz,
  zlib-ng,
  # linux-only
  alsa-lib,
  bluez,
  libGL,
  libxext,
  libxrandr,
  libevdev,
  udev,
  vulkan-loader,
  # darwin-only
  moltenvk,

  # passthru
  testers,
  nix-update-script,
  xvfb-run,

  dolphinVariant ? "normal",
}:

let
  variantTable = {
    "normal" = finalAttrs: {
      pname = "dolphin-emu";
      version = "2609a"; # Please backport to stable for netplay compat

      src = fetchFromGitHub {
        owner = "dolphin-emu";
        repo = "dolphin";
        tag = finalAttrs.version;
        hash = "sha256-0yQVW7Q3EKqfGihVA9I8Ucs0Hn/QVGVXuZ8ePbCZ5TQ=";
        fetchSubmodules = true;
        leaveDotGit = true;
        postFetch = ''
          pushd $out
          git rev-parse HEAD 2>/dev/null >$out/COMMIT
          find $out -name .git -print0 | xargs -0 rm -rf
          popd
        '';
      };

      darwinAppName = "Dolphin";

      patches = [ ];

      versionTestAttrs = {
        command = "${lib.getExe xvfb-run} dolphin-emu --version";
        version = finalAttrs.version;
      };

      meta = {
        homepage = "https://dolphin-emu.org";
        description = "Gamecube/Wii/Triforce emulator for x86_64 and ARMv8";
        mainProgram = if stdenv.hostPlatform.isDarwin then "Dolphin" else "dolphin-emu";
        branch = "master";
        license = lib.licenses.gpl2Plus;
        platforms = lib.platforms.unix;
        maintainers = with lib.maintainers; [ pbsds ];
      };
    };

    "primehack" = finalAttrs: {
      pname = "dolphin-emu-primehack";
      version = "1.0.9";

      src = fetchFromGitHub {
        owner = "shiiion";
        repo = "dolphin";
        tag = finalAttrs.version;
        hash = "sha256-SLTsDHDhBa1d5XOxQRNKBiBpIIntir9D4rhQtQz4w44=";
        fetchSubmodules = true;
        leaveDotGit = true;
        postFetch = ''
          pushd $out
          git rev-parse HEAD 2>/dev/null >$out/COMMIT
          find $out -name .git -print0 | xargs -0 rm -rf
          popd
        '';
      };

      patches = [
        (fetchpatch {
          name = "fmt12.patch"; # https://github.com/dolphin-emu/dolphin/pull/14694
          url = "https://github.com/dolphin-emu/dolphin/commit/8328469f5e48ba455d97ad15ebb9289170a662aa.patch";
          hash = "sha256-Ua5UVOczVtovhJ2g9UdSq93jXEeP968wlaXBWaYwi/s=";
        })

        # Rename everything that would collide with dolphin-emu
        ./primehack-rename-files.patch
      ];

      darwinAppName = "PrimeHack";

      versionTestAttrs = {
        command = "dolphin-emu-primehack-nogui --version";
        version = "PrimeHack";
      };

      meta = {
        homepage = "https://github.com/shiiion/dolphin";
        changelog = "https://github.com/shiiion/dolphin/releases/tag/${finalAttrs.version}";
        description = "Dolphin fork with Metroid Prime Trilogy mouse and keyboard controls";
        mainProgram = if stdenv.hostPlatform.isDarwin then "PrimeHack" else "dolphin-emu-primehack";
        maintainers = with lib.maintainers; [ mistyttm ];
        teams = with lib.teams; [ gaming ];
      };
    };
  };

  isPrimehack = dolphinVariant == "primehack";
in
stdenv.mkDerivation (
  finalAttrs:
  let
    variantInfo = variantTable.${dolphinVariant} finalAttrs;
  in
  {
    __structuredAttrs = true;

    inherit (variantInfo)
      pname
      version
      src
      meta
      patches
      ;

    postPatch = ''
      # use PlistBuddy from PATH
      substituteInPlace CMake/DolphinInjectVersionInfo.cmake \
        --replace-fail "/usr/libexec/PlistBuddy" "PlistBuddy"
    ''
    + lib.optionalString isPrimehack ''
      # the NSView type from AppKit is not being found
      substituteInPlace Source/Core/InputCommon/ControllerInterface/Quartz/QuartzKeyboardAndMouse.h --replace-fail \
        '#include <QuartzCore/QuartzCore.h>' \
        $'#include <QuartzCore/QuartzCore.h>\n#include <AppKit/AppKit.h>'
    '';

    strictDeps = true;

    nativeBuildInputs = [
      cmake
      pkg-config
      qt6.wrapQtAppsHook
      wrapGAppsHook3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      re-plistbuddy # for plutil as well
    ];

    buildInputs = [
      bzip2
      cubeb
      curl
      enet
      ffmpeg
      fmt
      glslang
      gtest
      hidapi
      libxdmcp
      libpulseaudio
      libspng
      libusb1
      lz4
      lzo
      #mbedtls_2 # Use vendored, as using nixpkgs' would mark the package unsafe
      miniupnpc
      minizip-ng
      openal
      pugixml
      qt6.qtbase
      qt6.qtsvg
      sdl3
      sfml
      xxhash
      xz
      zlib-ng
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      bluez
      libGL
      libxext
      libxrandr
      libevdev
      # FIXME: Vendored version is newer than mgba's stable release, remove the comment on next mgba's version
      #mgba # Derivation doesn't support Darwin
      udev
      vulkan-loader
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      moltenvk
    ];

    cmakeFlags = [
      (lib.cmakeFeature "DISTRIBUTOR" "NixOS")
      (lib.cmakeFeature "DOLPHIN_WC_DESCRIBE" finalAttrs.version)
      (lib.cmakeFeature "DOLPHIN_WC_BRANCH" "master")
      # CMake 4 dropped support of versions lower than 3.5,
      # versions lower than 3.10 are deprecated.
      (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      (lib.cmakeBool "OSX_USE_DEFAULT_SEARCH_PATH" true)
      (lib.cmakeBool "USE_BUNDLED_MOLTENVK" false)
      (lib.cmakeBool "MACOS_CODE_SIGNING" false)
      # Bundles the application folder into a standalone executable, so we cannot devendor libraries
      (lib.cmakeBool "SKIP_POSTPROCESS_BUNDLE" true)
      # Needs xcode so compilation fails with it enabled. We would want the version to be fixed anyways.
      # Note: The updater isn't available on linux, so we don't need to disable it there.
      (lib.cmakeBool "ENABLE_AUTOUPDATE" false)
    ];
    preConfigure = ''
      appendToVar cmakeFlags "-DDOLPHIN_WC_REVISION=$(cat COMMIT)"
      rm COMMIT
    '';

    doInstallCheck = true;

    postInstall =
      lib.optionalString stdenv.hostPlatform.isLinux ''
        install -Dm644 $src/Data/51-usb-device.rules $out/etc/udev/rules.d/51-usb-device.rules
      ''
      + lib.optionalString stdenv.hostPlatform.isDarwin ''
        # Only gets installed automatically if the standalone executable is used
        appName=${variantInfo.darwinAppName}
        mkdir -p $out/Applications
        cp -r ./Binaries/$appName.app $out/Applications
        ln -s $out/Applications/$appName.app/Contents/MacOS/$appName $out/bin/$appName
      '';

    dontWrapGApps = true;

    qtWrapperArgs = lib.optionals stdenv.hostPlatform.isLinux [
      "--prefix"
      "LD_LIBRARY_PATH"
      ":"
      (lib.makeLibraryPath [ vulkan-loader ])
    ];

    preFixup = ''
      qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
    '';

    passthru = {
      tests = {
        version = testers.testVersion {
          package = finalAttrs.finalPackage;
          inherit (variantInfo.versionTestAttrs) command version;
        };

      };
      updateScript = nix-update-script {
        extraArgs = [
          "--version-regex"
          "([0-9]+)"
        ];
      };
    };
  }
)
