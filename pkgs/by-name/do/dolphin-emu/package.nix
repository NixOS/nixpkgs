{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  pkg-config,
  qt6,
  wrapGAppsHook3,
  # darwin-only
  xcbuild,

  # buildInputs
  bzip2,
  cubeb,
  curl,
  enet,
  ffmpeg,
  fmt_10,
  gtest,
  hidapi,
  libXdmcp,
  libpulseaudio,
  libspng,
  libusb1,
  lz4,
  lzo,
  mbedtls_2,
  miniupnpc,
  minizip-ng,
  openal,
  pugixml,
  SDL2,
  sfml,
  xxHash,
  xz,
  # linux-only
  alsa-lib,
  bluez,
  libGL,
  libXext,
  libXrandr,
  libevdev,
  udev,
  vulkan-loader,
  # darwin-only
  moltenvk,

  # passthru
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dolphin-emu";
  version = "2506";

  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
    tag = finalAttrs.version;
    hash = "sha256-JEp1rc5nNJY4GfNCR2Vi4ctQ14p+LZWuFPFirv6foUM=";
    fetchSubmodules = true;
    leaveDotGit = true;
    postFetch = ''
      pushd $out
      git rev-parse HEAD 2>/dev/null >$out/COMMIT
      find $out -name .git -print0 | xargs -0 rm -rf
      popd
    '';
  };

  strictDeps = true;

  nativeBuildInputs =
    [
      cmake
      pkg-config
      qt6.wrapQtAppsHook
      wrapGAppsHook3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      xcbuild # for plutil
    ];

  buildInputs =
    [
      bzip2
      cubeb
      curl
      enet
      ffmpeg
      fmt_10
      gtest
      hidapi
      libXdmcp
      libpulseaudio
      libspng
      libusb1
      lz4
      lzo
      mbedtls_2
      miniupnpc
      minizip-ng
      openal
      pugixml
      qt6.qtbase
      qt6.qtsvg
      SDL2
      sfml
      xxHash
      xz
      # Causes linker errors with minizip-ng, prefer vendored. Possible reason why: https://github.com/dolphin-emu/dolphin/pull/12070#issuecomment-1677311838
      #zlib-ng
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      bluez
      libGL
      libXext
      libXrandr
      libevdev
      # FIXME: Vendored version is newer than mgba's stable release, remove the comment on next mgba's version
      #mgba # Derivation doesn't support Darwin
      udev
      vulkan-loader
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      moltenvk
    ];

  cmakeFlags =
    [
      (lib.cmakeFeature "DISTRIBUTOR" "NixOS")
      (lib.cmakeFeature "DOLPHIN_WC_DESCRIBE" finalAttrs.version)
      (lib.cmakeFeature "DOLPHIN_WC_BRANCH" "master")
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

  qtWrapperArgs = lib.optionals stdenv.hostPlatform.isLinux [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}"
    # https://bugs.dolphin-emu.org/issues/11807
    # The .desktop file should already set this, but Dolphin may be launched in other ways
    "--set QT_QPA_PLATFORM xcb"
  ];

  doInstallCheck = true;

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      install -D $src/Data/51-usb-device.rules $out/etc/udev/rules.d/51-usb-device.rules
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Only gets installed automatically if the standalone executable is used
      mkdir -p $out/Applications
      cp -r ./Binaries/Dolphin.app $out/Applications
      ln -s $out/Applications/Dolphin.app/Contents/MacOS/Dolphin $out/bin
    '';

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "dolphin-emu-nogui --version";
        inherit (finalAttrs) version;
      };
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "([0-9]+)"
      ];
    };
  };

  meta = {
    homepage = "https://dolphin-emu.org";
    description = "Gamecube/Wii/Triforce emulator for x86_64 and ARMv8";
    mainProgram = if stdenv.hostPlatform.isDarwin then "Dolphin" else "dolphin-emu";
    branch = "master";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    badPlatforms = [
      # error: implicit instantiation of undefined template 'std::char_traits<unsigned int>'
      lib.systems.inspect.patterns.isDarwin
    ];
    maintainers = with lib.maintainers; [ pbsds ];
  };
})
