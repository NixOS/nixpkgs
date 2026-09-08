{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  buildNpmPackage,
  wayland-scanner,
  autoPatchelfHook,
  autoAddDriverRunpath,
  udevCheckHook,
  nixosTests,
  # system deps
  boost,
  curl,
  libcap,
  libdrm,
  libevdev,
  libgbm,
  libopus,
  libva,
  libx11,
  libxext,
  libxfixes,
  libxrandr,
  miniupnpc,
  nlohmann_json,
  numactl,
  openssl,
  libpulseaudio,
  wayland,
  qt6,
  config,
  # CUDA (NVIDIA NVENC / NvFBC zero-copy capture) — see nixpkgs sunshine
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
}:
let
  inherit (stdenv.hostPlatform) isLinux;
  stdenv' = if cudaSupport then cudaPackages.backendStdenv else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "apollo";
  version = "0.5.1";

  __structuredAttrs = true;
  strictDeps = true;
  dontWrapQtApps = true;

  src = fetchFromGitHub {
    owner = "MrOz59";
    repo = "Hermes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9XeeJ8H+UfSpsqNmxriXbMNPlJOgUQ0G20ldi8e9ijE=";
    # pulls in the prebuilt FFmpeg static libs (third-party/build-deps)
    # and the vendored third-party sources
    fetchSubmodules = true;
  };

  # build the web UI separately so the CMake build doesn't need npm
  ui = buildNpmPackage {
    inherit (finalAttrs) src version;
    pname = "apollo-ui";
    # upstream ships no package-lock.json; vendor one so the
    # npm-deps phase can compute a deterministic hash
    postPatch = ''
      cp ${./package-lock.json} ./package-lock.json
    '';
    npmDepsHash = "sha256-xIjDF1uEqZmsgy+qy6XCZYrrzcqqkba7Ea8s4HmsevE=";

    # vite.config.js reads SUNSHINE_SOURCE_ASSETS_DIR / SUNSHINE_ASSETS_DIR;
    # with both unset it builds from src_assets/common/assets/web into
    # build/assets/web, which is what CMake installs from.
    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -a build "$out"

      runHook postInstall
    '';
  };

  # drop the web-ui custom target so CMake doesn't run npm at build time,
  # remove the systemd/udev discovery (we set the install dirs explicitly),
  # and drop Simple-Web-Server's boost system requirement (boost::system is
  # header-only since 1.74 and nixpkgs no longer builds a system component)
  postPatch = ''
    substituteInPlace cmake/targets/common.cmake \
      --replace-fail 'find_program(NPM npm REQUIRED)' "" \
      --replace-fail 'add_custom_target(web-ui ALL' 'add_custom_target(web-ui'

    substituteInPlace cmake/packaging/linux.cmake \
      --replace-fail 'find_package(Systemd)' "" \
      --replace-fail 'find_package(Udev)' ""

    substituteInPlace third-party/Simple-Web-Server/CMakeLists.txt \
      --replace-fail 'find_package(Boost 1.53.0 COMPONENTS system REQUIRED)' 'find_package(Boost 1.53.0 REQUIRED)'

    # rename the executable from sunshine to apollo so it matches the
    # packaged .desktop file, systemd unit and SUNSHINE_EXECUTABLE_PATH
    sed -i '/^add_executable(sunshine/a set_target_properties(sunshine PROPERTIES OUTPUT_NAME apollo SUFFIX "")' cmake/targets/common.cmake

    # upstream v0.5.1 half-renamed sunshine->hermes: the .desktop Exec points
    # at a 'hermes' systemd unit that is never installed (the unit ships as
    # sunshine.service), so the app-menu launcher is broken. Point the desktop
    # at the apollo binary (on PATH via environment.systemPackages, like
    # nixpkgs does for sunshine) and brand it Apollo.
    substituteInPlace packaging/linux/io.github.mroz59.Hermes.desktop \
      --replace-fail 'Exec=/usr/bin/env systemctl start --user hermes' 'Exec=apollo' \
      --replace-fail 'Name=@PROJECT_NAME@' 'Name=Apollo'

    # terminal launcher: point at the apollo binary too
    substituteInPlace packaging/linux/io.github.mroz59.Hermes.terminal.desktop \
      --replace-fail 'Exec=hermes' 'Exec=apollo'
  '';

  # the web-ui target is disabled (see above); place the prebuilt UI where
  # cmake/packaging/common.cmake installs it from. nixpkgs configures
  # in-source, so CMAKE_BINARY_DIR == the source root.
  postConfigure = ''
    cp -r ${finalAttrs.ui}/build/assets/web assets/web
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    wayland-scanner
    # prebuilt static FFmpeg libs need these at link time
    autoPatchelfHook
  ]
  ++ lib.optionals isLinux [ udevCheckHook ]
  ++ lib.optionals cudaSupport [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
    (lib.getDev cudaPackages.cuda_cudart)
  ];

  buildInputs = [
    boost
    curl
    libcap
    libdrm
    libevdev
    libgbm
    libopus
    libva
    libx11
    libxext
    libxfixes
    libxrandr
    miniupnpc
    nlohmann_json
    numactl
    openssl
    libpulseaudio
    qt6.qtbase
    qt6.qtsvg
    wayland
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cudatoolkit
    cudaPackages.cuda_cudart
  ];

  cmakeFlags = [
    # FFmpeg: use the prebuilt static libs shipped in the build-deps
    # submodule (third-party/build-deps/dist/Linux-x86_64). Do NOT set
    # FFMPEG_PREPARED_BINARIES explicitly — the "prepared" branch of
    # cmake/dependencies/common.cmake only links avcodec/swscale/avutil/cbs
    # and would drop the x264/x265/SvtAv1Enc/hdr10plus libs that this
    # particular ffmpeg build links against.
    # SUNSHINE_SOURCE_ASSETS_DIR keeps its default (src_assets/); the
    # prebuilt web UI is copied into the build dir in postConfigure.
    (lib.cmakeFeature "SUNSHINE_ASSETS_DIR" "share/${finalAttrs.pname}")
    # used in the generated systemd unit's ExecStart=
    (lib.cmakeFeature "SUNSHINE_EXECUTABLE_PATH" "${placeholder "out"}/bin/apollo")
    # where the generated unit/udev rules/modules-load files land
    (lib.cmakeBool "UDEV_FOUND" true)
    (lib.cmakeBool "SYSTEMD_FOUND" true)
    (lib.cmakeFeature "UDEV_RULES_INSTALL_DIR" "lib/udev/rules.d")
    (lib.cmakeFeature "SYSTEMD_USER_UNIT_INSTALL_DIR" "lib/systemd/user")
    (lib.cmakeFeature "SYSTEMD_MODULES_LOAD_DIR" "lib/modules-load.d")
    (lib.cmakeBool "BOOST_USE_STATIC" false)
    (lib.cmakeBool "BUILD_DOCS" false)
    (lib.cmakeBool "BUILD_TESTS" false)
    # upstream defaults SUNSHINE_ENABLE_CUDA=ON; set it explicitly so the
    # default (non-CUDA) build is deterministic and .cuda builds are correct
    (lib.cmakeBool "SUNSHINE_ENABLE_CUDA" cudaSupport)
  ];

  installPhase = ''
    runHook preInstall

    cmake --install .

    runHook postInstall
  '';

  # Explicit, deterministic install check. Running `apollo` with no args
  # starts the streaming server and never exits (would hang CI), so check
  # `--help` instead, which prints usage and exits 0.
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/${finalAttrs.meta.mainProgram} --help

    runHook postInstallCheck
  '';

  doInstallCheck = isLinux;

  passthru = {
    updateScript = ./updater.sh;
    tests = { inherit (nixosTests) apollo; };
  };

  meta = with lib; {
    description = "Apollo — self-hosted game stream host for Moonlight / Artemis / Hestia clients (Sunshine-derived, low-latency KMS capture)";
    homepage = "https://github.com/MrOz59/Hermes";
    license = licenses.gpl3Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "apollo";
    maintainers = [ lib.maintainers.NCBlizzard ];
  };
})
