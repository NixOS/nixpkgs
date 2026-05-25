{
  lib,
  stdenv,
  cmake,
  ninja,
  SDL2,
  boost,
  catch2_3,
  cpp-jwt,
  cubeb,
  enet,
  fetchFromGitea,
  fetchurl,
  ffmpeg-headless,
  fmt,
  frozen-containers,
  gamemode,
  glslang,
  httplib,
  kdePackages,
  libopus,
  libusb1,
  lz4,
  mcl-cpp-utility-lib,
  mbedtls,
  nix-update-script,
  nlohmann_json,
  oaknut,
  openssl,
  pipewire,
  pkg-config,
  python3,
  qt6,
  simpleini,
  sirit,
  spirv-headers,
  spirv-tools,
  stb,
  unordered_dense,
  vulkan-headers,
  vulkan-loader,
  vulkan-memory-allocator,
  vulkan-utility-libraries,
  xbyak,
  zlib,
  zstd,
  tzdata,
}:

let
  # Old yuzu compat list, the project does not publish its own at the moment
  compat-list = fetchurl {
    url = "https://raw.githubusercontent.com/flathub/org.yuzu_emu.yuzu/4abf1d239aba843180abfed58fa8541432fece5b/compatibility_list.json";
    hash = "sha256-OC22KdawYK9yKiffqc1rtgrBanVExYMi9jqhvkwMD6w=";
  };

  nx_tzdb = stdenv.mkDerivation (finalAttrs: {
    name = "tzdb_to_nx";
    version = "120226";

    src = fetchFromGitea {
      domain = "git.crueter.xyz";
      owner = "misc";
      repo = "tzdb_to_nx";
      tag = finalAttrs.version;
      hash = "sha256-egPu8UVbj73RQ0Z5JMTjd5HVdy47WTfkUMlQaS0wUTg=";
    };

    nativeBuildInputs = [
      cmake
      ninja
    ];

    cmakeFlags = [
      (lib.cmakeFeature "TZDB2NX_ZONEINFO_DIR" "${tzdata}/share/zoneinfo")
      (lib.cmakeFeature "TZDB2NX_VERSION" tzdata.version)
    ];

    ninjaFlags = [ "x80e" ];

    installPhase = ''
      runHook preInstall

      cp -r src/tzdb/nx $out

      runHook postInstall
    '';
  });
in

stdenv.mkDerivation (finalAttrs: {
  pname = "eden";
  version = "0.1.1";

  src = fetchFromGitea {
    domain = "git.eden-emu.dev";
    owner = "eden-emu";
    repo = "eden";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tkro7ZHgn2809Utf/Li5+OiseywyQKH15eqphxlJZQQ=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    glslang
    pkg-config
    python3
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    boost
    cpp-jwt
    cubeb
    enet
    ffmpeg-headless
    fmt
    frozen-containers
    gamemode
    httplib
    kdePackages.quazip
    libopus
    libusb1
    # intentionally omitted: LLVM - heavy, only used for stack traces in the debugger
    lz4
    mcl-cpp-utility-lib
    nlohmann_json
    openssl
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtwayland
    qt6.qtwebengine
    # intentionally omitted: renderdoc - heavy, developer only
    SDL2
    stb
    simpleini
    spirv-tools
    spirv-headers
    vulkan-headers
    vulkan-memory-allocator
    vulkan-utility-libraries
    mbedtls
    sirit
    unordered_dense
    zlib
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    xbyak
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    oaknut
  ];

  patches = [
    # https://git.eden-emu.dev/eden-emu/eden/issues/3484
    ./aarch64-disable-fastmem.patch
  ];

  doCheck = true;

  checkInputs = [
    catch2_3
    oaknut
  ];

  __structuredAttrs = true;
  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "YUZU_TESTS" false) # some timer tests are flaky

    # use system libraries
    (lib.cmakeBool "CPMUTIL_FORCE_SYSTEM" true)
    (lib.cmakeBool "YUZU_USE_EXTERNAL_SDL2" false)
    (lib.cmakeBool "YUZU_USE_BUNDLED_FFMPEG" false)
    (lib.cmakeFeature "YUZU_TZDB_PATH" "${nx_tzdb}")

    # enable some optional features
    (lib.cmakeBool "YUZU_USE_QT_WEB_ENGINE" true)
    (lib.cmakeBool "YUZU_USE_QT_MULTIMEDIA" true)
    (lib.cmakeBool "ENABLE_QT_TRANSLATION" true)

    # We dont want to bother upstream with potentially outdated compat reports
    (lib.cmakeBool "YUZU_ENABLE_COMPATIBILITY_REPORTING" false)

    (lib.cmakeFeature "TITLE_BAR_FORMAT_IDLE" "${finalAttrs.pname} | ${finalAttrs.version} (nixpkgs) {}")
    (lib.cmakeFeature "TITLE_BAR_FORMAT_RUNNING" "${finalAttrs.pname} | ${finalAttrs.version} (nixpkgs) | {}")
  ];

  postConfigure = ''
    ln -sf ${compat-list} ./dist/compatibility_list/compatibility_list.json
  '';

  postInstall = ''
    install -Dm444 $src/dist/72-yuzu-input.rules $out/lib/udev/rules.d/72-yuzu-input.rules
  '';

  preFixup = ''
    qtWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        vulkan-loader
        pipewire
      ]
    })
  '';

  passthru = {
    inherit nx_tzdb compat-list;

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switch 1 emulator derived from Yuzu and Sudachi";
    homepage = "https://eden-emu.dev/";
    mainProgram = "eden";
    maintainers = with lib.maintainers; [ marcin-serwin ];
    license = with lib.licenses; [
      # Primary
      gpl3Plus

      # Build system
      lgpl3Plus

      # Dynarmic and Yuzu code
      gpl2Plus
      bsd0

      # Icons
      cc-by-40
      cc-by-sa-30
      cc0

      # Timezone data
      publicDomain

      # Vendored/incorporated libs
      apsl20
      llvm-exception
      lib.licenses.boost
      bsd2
      bsd3
      mit
      mpl20
      wtfpl
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
