{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  qt6,
  cryptopp,
  fmt,
  libarchive,
  nlohmann_json,
  pugixml,
  sdl3,
  toml11,
  vulkan-headers,
  vulkan-loader,
  vulkan-volk,
  zarchive,
  zstd,
  nix-update-script,
  shadps4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bb-launcher";
  version = "16.10";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "rainmakerv3";
    repo = "BB_Launcher";
    tag = "Release${finalAttrs.version}";
    hash = "sha256-hyjMeRtZfEfhz0k1VNpgLN046cvbMWJfK8U5Jy+j1B4=";

    # qmicroz is the only external left after unbundle-externals.patch, and
    # qtstatic is a big prebuilt Qt for Windows only, so free some disk space.
    postCheckout = ''
      git -C "$out/externals" submodule update --init microz
      rm -r "$out/qtstatic" "$out/WebView2SDK"
    '';
  };

  patches = [
    # Devendor various vendored dependencies in favor of linking against nixpkgs' versions.
    # Only qmicroz and the miniz it carries stay vendored, being unpackaged.
    # Of the forked pins there (fmt, sdl3, cryptopp) only cryptopp diverges, in
    # clang-cl branches inactive here.
    # Recheck if any divergence was added when updating.
    ./unbundle-externals.patch
  ]
  # BB_Launcher otherwise only runs builds the user picks in its file dialog or
  # downloads through it, and those downloads are dynamically linked binaries.
  # Selecting a /nix/store path by hand would go stale quickly.
  # This patch injects ${shadps4} if the set one either doesn't exist, or is a
  # /nix/store path (which may be stale by now).
  # If a user doesn't want that, they can simply do `bb-launcher.override { shadps4 = null; }`
  ++ lib.optional (shadps4 != null) ./use-nix-shadps4.patch;

  postPatch = lib.optionalString (shadps4 != null) ''
    substituteInPlace settings/config.cpp \
      --subst-var-by shadps4 ${lib.getExe shadps4} \
      --subst-var-by storeDir ${builtins.storeDir}
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwebsockets
    qt6.qtwebview
    qt6.qtwebengine
    qt6.qtwebchannel
    cryptopp
    fmt
    libarchive
    nlohmann_json
    pugixml
    sdl3
    toml11
    vulkan-headers
    vulkan-volk
    zarchive
    zstd
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_WEBENGINE" true)
  ];

  # volk dlopens the loader at runtime
  qtWrapperArgs = [
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [ vulkan-loader ])
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "Release(.*)"
    ];
  };

  meta = {
    description = "Dedicated shadPS4 launcher focused entirely on Bloodborne";
    longDescription = ''
      BB_Launcher is a dedicated shadPS4 launcher focused entirely on
      Bloodborne, with mod management, save/trophy management and a shadPS4
      settings editor.

      It runs the packaged shadPS4 by default. Override `shadps4` to run a
      different build, or set `shadps4 = null` to manage builds entirely from
      within the app.
    '';
    homepage = "https://github.com/rainmakerv3/BB_Launcher";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kilyanni ];
    mainProgram = "BB_Launcher";
    platforms = [ "x86_64-linux" ];
  };
})
