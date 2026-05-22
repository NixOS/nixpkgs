{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  autoPatchelfHook,
  autoAddDriverRunpath,
  makeWrapper,
  buildNpmPackage,
  nixosTests,
  cmake,
  avahi,
  libevdev,
  libpulseaudio,
  pipewire,
  libxtst,
  libxrandr,
  libxi,
  libxfixes,
  libxdmcp,
  libx11,
  libxcb,
  openssl,
  libopus,
  boost,
  pkg-config,
  libdrm,
  wayland,
  wayland-scanner,
  libffi,
  libcap,
  libgbm,
  curl,
  pcre,
  pcre2,
  python3,
  libuuid,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  libxkbcommon,
  libepoxy,
  libva,
  libvdpau,
  libglvnd,
  numactl,
  amf-headers,
  svt-av1,
  vulkan-loader,
  glslang,
  libappindicator,
  libnotify,
  miniupnpc,
  nlohmann_json,
  config,
  coreutils,
  udevCheckHook,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
  apple-sdk_15,
}:
let
  inherit (stdenv.hostPlatform) isDarwin isLinux;
  stdenv' = if cudaSupport then cudaPackages.backendStdenv else stdenv;

  version = "2026.516.143833";

  # Prebuilt FFmpeg binaries from build-deps release matching the submodule commit
  ffmpegDepsTag = "v2026.516.30821";
  ffmpegArch =
    {
      x86_64-linux = "Linux-x86_64";
      aarch64-linux = "Linux-aarch64";
      powerpc64le-linux = "Linux-ppc64le";
      x86_64-darwin = "Darwin-x86_64";
      aarch64-darwin = "Darwin-arm64";
    }
    .${stdenv.hostPlatform.system} or (throw "sunshine: unsupported platform ${stdenv.hostPlatform.system} for prebuilt FFmpeg binaries");
  ffmpegHash =
    {
      x86_64-linux = "sha256-wyMZ/MKGe+/o/zria006WDeMOpwb/vkCnJlpMhw7xuw=";
      aarch64-linux = "sha256-ELbJRAumF47DuUT2xvaXJTSXytUZbSOi0y0zXargBi4=";
      powerpc64le-linux = "sha256-i3sLpeqhK8m/tuNWH7FKUEU85oj2yMq4GqcPuFvE4/s=";
      x86_64-darwin = "sha256-/OUePstB1gw5sDeKVI54bF4R5sWDT9uAWmzFMbRFi/A=";
      aarch64-darwin = "sha256-cHgTuBWQ2A8PQR4F3brJpOLxxNvB4/YdMtUSRUMXv6Y=";
    }
    .${stdenv.hostPlatform.system};
  ffmpegBinaries = stdenv.mkDerivation {
    pname = "sunshine-ffmpeg-binaries";
    version = ffmpegDepsTag;

    src = fetchurl {
      url = "https://github.com/LizardByte/build-deps/releases/download/${ffmpegDepsTag}/${ffmpegArch}-ffmpeg.tar.gz";
      hash = ffmpegHash;
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';
  };
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "sunshine";
  inherit version;

  src = fetchFromGitHub {
    owner = "LizardByte";
    repo = "Sunshine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3yuhOyW1Rqz4ddZ40z2ZzpAReZQFva0SL595XrnFB60=";
    fetchSubmodules = true;
  };

  # build webui
  ui = buildNpmPackage {
    inherit (finalAttrs) src version;
    pname = "sunshine-ui";
    npmDepsHash = "sha256-YnNnuAdj/S5LGNytqIsmCApIec8DTWKF6VIJ7AXUctU=";

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -a . "$out"/
      runHook postInstall
    '';
  };

  postPatch =
    # don't look for npm since we build webui separately
    ''
      substituteInPlace cmake/targets/common.cmake \
        --replace-fail 'find_program(NPM npm REQUIRED)' ""
    ''
    # use system boost instead of FetchContent.
    + ''
      substituteInPlace cmake/dependencies/Boost_Sunshine.cmake \
        --replace-fail 'set(BOOST_VERSION "1.89.0")' 'set(BOOST_VERSION "${boost.version}")'
      echo 'set(FETCH_CONTENT_BOOST_USED TRUE)' >> cmake/dependencies/Boost_Sunshine.cmake
    ''
    # remove upstream dependency on systemd and udev
    + lib.optionalString isLinux ''
      substituteInPlace cmake/packaging/linux.cmake \
        --replace-fail 'find_package(Systemd)' "" \
        --replace-fail 'find_package(Udev)' ""

      substituteInPlace packaging/linux/dev.lizardbyte.app.Sunshine.desktop \
        --subst-var-by PROJECT_NAME 'Sunshine' \
        --subst-var-by PROJECT_DESCRIPTION 'Self-hosted game stream host for Moonlight' \
        --subst-var-by SUNSHINE_DESKTOP_ICON 'sunshine' \
        --subst-var-by CMAKE_INSTALL_FULL_DATAROOTDIR "$out/share" \
        --replace-fail '/usr/bin/env systemctl start --u app-@PROJECT_FQDN@' 'sunshine'

      substituteInPlace packaging/linux/app-dev.lizardbyte.app.Sunshine.service.in \
        --subst-var-by PROJECT_DESCRIPTION 'Self-hosted game stream host for Moonlight' \
        --subst-var-by SUNSHINE_SERVICE_START_COMMAND "ExecStart=$out/bin/sunshine" \
        --subst-var-by SUNSHINE_SERVICE_STOP_COMMAND "" \
        --replace-fail '/bin/sleep' '${lib.getExe' coreutils "sleep"}'
    '';

  nativeBuildInputs = [
    cmake
    pkg-config
    (python3.withPackages (
      ps: with ps; [
        jinja2
        setuptools
      ]
    ))
    makeWrapper
  ]
  ++ lib.optionals isLinux [
    wayland-scanner
    # Avoid fighting upstream's usage of vendored ffmpeg libraries
    autoPatchelfHook
    glslang
  ]
  ++ lib.optionals cudaSupport [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
    (lib.getDev cudaPackages.cuda_cudart)
  ];

  buildInputs = [
    boost
    curl
    miniupnpc
    nlohmann_json
    openssl
    libopus
  ]
  ++ lib.optionals isLinux [
    avahi
    libevdev
    libpulseaudio
    pipewire
    libx11
    libxcb
    libxfixes
    libxrandr
    libxtst
    libxi
    libdrm
    wayland
    libffi
    libevdev
    libcap
    libdrm
    pcre
    pcre2
    libuuid
    libselinux
    libsepol
    libthai
    libdatrie
    libxdmcp
    libxkbcommon
    libepoxy
    libva
    libvdpau
    numactl
    libgbm
    amf-headers
    svt-av1
    vulkan-loader
    libappindicator
    libnotify
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cudatoolkit
    cudaPackages.cuda_cudart
  ]
  ++ lib.optionals isDarwin [
    apple-sdk_15
  ];

  runtimeDependencies = lib.optionals isLinux [
    avahi
    libgbm
    libxrandr
    libxcb
    libglvnd
  ];

  cmakeFlags = [
    "-Wno-dev"
    (lib.cmakeBool "BOOST_USE_STATIC" false)
    (lib.cmakeBool "BUILD_DOCS" false)
    (lib.cmakeFeature "SUNSHINE_PUBLISHER_NAME" "nixpkgs")
    (lib.cmakeFeature "SUNSHINE_PUBLISHER_WEBSITE" "https://nixos.org")
    (lib.cmakeFeature "SUNSHINE_PUBLISHER_ISSUE_URL" "https://github.com/NixOS/nixpkgs/issues")
    (lib.cmakeBool "GLAD_SKIP_PIP_INSTALL" true)
    (lib.cmakeFeature "FFMPEG_PREPARED_BINARIES" "${ffmpegBinaries}")
  ]
  # upstream tries to use systemd and udev packages to find these directories in FHS; set the paths explicitly instead
  ++ lib.optionals isLinux [
    (lib.cmakeBool "UDEV_FOUND" true)
    (lib.cmakeBool "SYSTEMD_FOUND" true)
    (lib.cmakeFeature "UDEV_RULES_INSTALL_DIR" "lib/udev/rules.d")
    (lib.cmakeFeature "SYSTEMD_USER_UNIT_INSTALL_DIR" "lib/systemd/user")
    (lib.cmakeFeature "SYSTEMD_MODULES_LOAD_DIR" "lib/modules-load.d")
  ]
  ++ lib.optionals (!cudaSupport) [
    (lib.cmakeBool "SUNSHINE_ENABLE_CUDA" false)
  ]
  ++ lib.optionals isDarwin [
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "23")
    (lib.cmakeFeature "OPENSSL_ROOT_DIR" "${openssl.dev}")
    (lib.cmakeFeature "SUNSHINE_ASSETS_DIR" "sunshine/assets")
    (lib.cmakeBool "SUNSHINE_BUILD_HOMEBREW" true)
  ];

  env = {
    # needed to trigger CMake version configuration
    BUILD_VERSION = "${finalAttrs.version}";
    BRANCH = "master";
    COMMIT = "";
  };

  # copy webui where it can be picked up by build
  preBuild = ''
    cp -r ${finalAttrs.ui}/build ../
  '';

  buildFlags = [
    "sunshine"
  ];

  # redefine installPhase to avoid attempt to build webui
  installPhase = ''
    runHook preInstall

    cmake --install .

    runHook postInstall
  '';

  postInstall = lib.optionalString isLinux ''
    install -Dm644 ../packaging/linux/dev.lizardbyte.app.Sunshine.desktop $out/share/applications/dev.lizardbyte.app.Sunshine.desktop
  '';

  # allow Sunshine to find libvulkan
  postFixup = lib.optionalString cudaSupport ''
    wrapProgram $out/bin/sunshine \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  doInstallCheck = isLinux;

  nativeInstallCheckInputs = lib.optionals isLinux [ udevCheckHook ];

  passthru = {
    tests = lib.optionalAttrs isLinux {
      sunshine = nixosTests.sunshine;
    };
    updateScript = ./updater.sh;
  };

  meta = {
    description = "Game stream host for Moonlight";
    homepage = "https://github.com/LizardByte/Sunshine";
    license = lib.licenses.gpl3Only;
    mainProgram = "sunshine";
    maintainers = with lib.maintainers; [
      devusb
      anish
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "powerpc64le-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
