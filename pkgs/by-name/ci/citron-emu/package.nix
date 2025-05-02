{
  lib,
  stdenv,
  SDL2,
  boost,
  catch2_3,
  cmake,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchpatch,
  cpp-jwt,
  cubeb,
  enet,
  fetchgit,
  fetchurl,
  ffmpeg-headless,
  fmt_11,
  glslang,
  libopus,
  libusb1,
  lz4,
  python3,
  unzip,
  nix-update-script,
  nlohmann_json,
  pkg-config,
  qt6,
  rapidjson,
  spirv-tools,
  spirv-headers,
  vulkan-utility-libraries,
  vulkan-headers,
  vulkan-loader,
  simpleini,
  zlib,
  vulkan-memory-allocator,
  zstd,
}:

let
  inherit (qt6)
    qtbase
    qtmultimedia
    qtwayland
    wrapQtAppsHook
    qttools
    qtwebengine
    ;

  compat-list = stdenv.mkDerivation {
    pname = "yuzu-compatibility-list";
    version = "unstable-2024-02-26";

    src = fetchFromGitHub {
      owner = "flathub";
      repo = "org.yuzu_emu.yuzu";
      rev = "9c2032a3c7e64772a8112b77ed8b660242172068";
      hash = "sha256-ITh/W4vfC9w9t+TJnPeTZwWifnhTNKX54JSSdpgaoBk=";
    };

    buildCommand = ''
      cp $src/compatibility_list.json $out
    '';
  };

  nx_tzdb = stdenv.mkDerivation rec {
    pname = "nx_tzdb";
    version = "221202";

    src = fetchurl {
      url = "https://github.com/lat9nq/tzdb_to_nx/releases/download/${version}/${version}.zip";
      hash = "sha256-mRzW+iIwrU1zsxHmf+0RArU8BShAoEMvCz+McXFFK3c=";
    };

    nativeBuildInputs = [ unzip ];

    buildCommand = ''
      unzip $src -d $out
    '';

  };

in

stdenv.mkDerivation (finalAttrs: {
  pname = "citron";
  version = "0.6.1";

  src = fetchFromGitLab {
    domain = "git.citron-emu.org";
    owner = "citron";
    repo = "emu";
    rev = "7edbccbdc9e0558bf5cff4981f54103ca0c5e27e";
    hash = "sha256-rF6SCi1pXlZN62I8zEeG8I/rTUWFMUa/yGITiz7xne4=";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  patches = [
    # Add explicit cast for CRC checksum value
    ./fix-udp-protocol.patch
    (fetchpatch {
        url = "https://git.citron-emu.org/citron/emu/-/commit/21ca0b31191c4af56a78576c502e8382b4c128b4.patch";
        hash = "sha256-DkCGjeNYjCA7RdB+hBRXuHL8Ckjb+IgWbZ13leQZUF0=";
      }
    )
  ];

  nativeBuildInputs = [
    cmake
    glslang
    pkg-config
    python3
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    # vulkan-headers must come first, so the older propagated versions
    # don't get picked up by accident
    vulkan-headers

    boost
    catch2_3
    cpp-jwt
    cubeb
    # intentionally omitted: dynarmic - prefer vendored version for compatibility
    enet

    ffmpeg-headless
    fmt_11
    # intentionally omitted: gamemode - loaded dynamically at runtime
    # intentionally omitted: httplib - upstream requires an older version than what we have
    libopus
    libusb1
    # intentionally omitted: LLVM - heavy, only used for stack traces in the debugger
    lz4
    nlohmann_json
    qtbase
    qtmultimedia
    qtwayland
    qtwebengine
    rapidjson
    # intentionally omitted: renderdoc - heavy, developer only
    SDL2
    # intentionally omitted: stb - header only libraries, vendor uses git snapshot
    simpleini
    spirv-tools
    spirv-headers
    vulkan-memory-allocator
    vulkan-utility-libraries
    # intentionally omitted: xbyak - prefer vendored version for compatibility
    zlib
    zstd
  ];

  # This changes `ir/opt` to `ir/var/empty` in `externals/dynarmic/src/dynarmic/CMakeLists.txt`
  # making the build fail, as that path does not exist
  dontFixCmake = true;

  __structuredAttrs = true;
  cmakeFlags = [
    # actually has a noticeable performance impact
    (lib.cmakeBool "CITRON_ENABLE_LTO" true)
    (lib.cmakeBool "CITRON_TESTS" false)

    (lib.cmakeBool "ENABLE_QT6" true)
    (lib.cmakeBool "ENABLE_QT_TRANSLATION" true)

    # use system libraries
    # NB: "external" here means "from the externals/ directory in the source",
    # so "false" means "use system"
    (lib.cmakeBool "CITRON_USE_EXTERNAL_SDL2" false)
    (lib.cmakeBool "CITRON_USE_EXTERNAL_VULKAN_HEADERS" false)
    (lib.cmakeBool "CITRON_USE_EXTERNAL_VULKAN_UTILITY_LIBRARIES" false)
    (lib.cmakeBool "CITRON_USE_EXTERNAL_VULKAN_SPIRV_TOOLS" false)

    # don't check for missing submodules
    (lib.cmakeBool "CITRON_CHECK_SUBMODULES" false)

    # enable some optional features
    (lib.cmakeBool "CITRON_USE_QT_WEB_ENGINE" true)
    (lib.cmakeBool "CITRON_USE_QT_MULTIMEDIA" true)
    (lib.cmakeBool "USE_DISCORD_PRESENCE" true)

    # We dont want to bother upstream with potentially outdated compat reports
    (lib.cmakeBool "CITRON_ENABLE_COMPATIBILITY_REPORTING" false)
    (lib.cmakeBool "ENABLE_COMPATIBILITY_LIST_DOWNLOAD" false) # We provide this deterministically

    (lib.cmakeFeature "TITLE_BAR_FORMAT_IDLE" "${finalAttrs.pname} | ${finalAttrs.version} (nixpkgs) {}")
    (lib.cmakeFeature "TITLE_BAR_FORMAT_RUNNING" "${finalAttrs.pname} | ${finalAttrs.version} (nixpkgs) | {}")
  ];

  env = {
    # Does some handrolled SIMD
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isx86_64 "-msse4.1";
  };

  qtWrapperArgs = [
    # Fixes vulkan detection.
    # FIXME: patchelf --add-rpath corrupts the binary for some reason, investigate
    "--prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib"
  ];

  preConfigure = ''
    # provide pre-downloaded tz data
    mkdir -p build/externals/nx_tzdb
    ln -s ${nx_tzdb} build/externals/nx_tzdb/nx_tzdb
  '';

  postConfigure = ''
    ln -sf ${compat-list} ./dist/compatibility_list/compatibility_list.json
  '';

  postInstall = "
    install -Dm444 $src/dist/72-citron-input.rules $out/lib/udev/rules.d/72-citron-input.rules
  ";

  meta = {
    description = "Fork of yuzu, an open-source Nintendo Switch emulator";
    homepage = "https://notabug.org/litucks/torzu";
    mainProgram = "citron";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ liberodark ];
    license = with lib.licenses; [
      gpl3Plus
      # Icons
      asl20
      mit
      cc0
    ];
  };
})
