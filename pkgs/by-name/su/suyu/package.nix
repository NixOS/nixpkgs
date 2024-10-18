{ lib
, SDL2
, autoconf
, boost
, catch2_3
, cmake
, fetchFromGitHub
, cpp-jwt
, cubeb
, discord-rpc
, enet
, fetchgit
, fetchurl
, ffmpeg-headless
, fmt
, glslang
, libopus
, libusb1
, libva
, lz4
, unzip
, nix-update-script
, nlohmann_json
, nv-codec-headers-12
, pkg-config
, qt6
, stdenv
, vulkan-headers
, vulkan-loader
, yasm
, zlib
, zstd
}:

let
  inherit (qt6) qtbase
    qtmultimedia
    qtwayland
    wrapQtAppsHook
    qttools
    qtwebengine;

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

stdenv.mkDerivation(finalAttrs: {
  pname = "suyu";
  version = "0.0.3";

  src = fetchgit {
    url = "https://git.suyu.dev/suyu/suyu";
    rev = "v${finalAttrs.version}";
    sha256 = "wLUPNRDR22m34OcUSB1xHd+pT7/wx0pHYAZj6LnEN4g=";
  };

  nativeBuildInputs = [
    cmake
    glslang
    pkg-config
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
    discord-rpc
    # intentionally omitted: dynarmic - prefer vendored version for compatibility
    enet

    # ffmpeg deps (also includes vendored)
    # we do not use internal ffmpeg because cuda errors
    autoconf
    yasm
    libva  # for accelerated video decode on non-nvidia
    nv-codec-headers-12  # for accelerated video decode on nvidia
    ffmpeg-headless
    # end ffmpeg deps

    fmt
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
    # intentionally omitted: renderdoc - heavy, developer only
    SDL2
    # not packaged in nixpkgs: simpleini
    # intentionally omitted: stb - header only libraries, vendor uses git snapshot
    # not packaged in nixpkgs: vulkan-memory-allocator
    # intentionally omitted: xbyak - prefer vendored version for compatibility
    zlib
    zstd
  ];

  # This changes `ir/opt` to `ir/var/empty` in `externals/dynarmic/src/dynarmic/CMakeLists.txt`
  # making the build fail, as that path does not exist
  dontFixCmake = true;

  cmakeFlags = [
    # actually has a noticeable performance impact
    "-DSUYU_ENABLE_LTO=ON"

    # build with qt6
    "-DENABLE_QT6=ON"
    "-DENABLE_QT_TRANSLATION=ON"

    # use system libraries
    # NB: "external" here means "from the externals/ directory in the source",
    # so "off" means "use system"
    "-DSUYU_USE_EXTERNAL_SDL2=OFF"
    "-DSUYU_USE_EXTERNAL_VULKAN_HEADERS=OFF"

    # # don't use system ffmpeg, suyu uses internal APIs
    # "-DSUYU_USE_BUNDLED_FFMPEG=ON"

    # don't check for missing submodules
    "-DSUYU_CHECK_SUBMODULES=OFF"

    # enable some optional features
    "-DSUYU_USE_QT_WEB_ENGINE=ON"
    "-DSUYU_USE_QT_MULTIMEDIA=ON"
    "-DUSE_DISCORD_PRESENCE=ON"

    # We dont want to bother upstream with potentially outdated compat reports
    "-DSUYU_ENABLE_COMPATIBILITY_REPORTING=OFF"
    "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF" # We provide this deterministically
  ];

  # Does some handrolled SIMD
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isx86_64 "-msse4.1";

  # Fixes vulkan detection.
  # FIXME: patchelf --add-rpath corrupts the binary for some reason, investigate
  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib"
  ];

    # see https://github.com/NixOS/nixpkgs/issues/114044, setting this through cmakeFlags does not work.
  preConfigure = ''
    cmakeFlagsArray+=(
      "-DTITLE_BAR_FORMAT_IDLE=${finalAttrs.pname} | ${finalAttrs.version} (nixpkgs) {}"
      "-DTITLE_BAR_FORMAT_RUNNING=${finalAttrs.pname} | ${finalAttrs.version} (nixpkgs) | {}"
    )

    # provide pre-downloaded tz data
    mkdir -p build/externals/nx_tzdb
    ln -s ${nx_tzdb} build/externals/nx_tzdb/nx_tzdb
  '';

  postConfigure = ''
    ln -sf ${compat-list} ./dist/compatibility_list/compatibility_list.json
  '';


  postInstall = "
    install -Dm444 $src/dist/72-suyu-input.rules $out/lib/udev/rules.d/72-suyu-input.rules
  ";

  meta = with lib; {
    homepage = "https://suyu.dev";
    changelog = "https://suyu.dev/blog";
    description = "An experimental Nintendo Switch emulator written in C++";
    longDescription = ''
      An experimental Nintendo Switch emulator written in C++.
      Using the master/ branch is recommended for general usage.
      Using the dev branch is recommended if you would like to try out experimental features, with a cost of stability.
    '';
    mainProgram = "suyu";
    platforms = [ "aarch64-linux" "x86_64-linux" ];
    license = with licenses; [
      gpl3Plus
      # Icons
      asl20 mit cc0
    ];
  };
})
