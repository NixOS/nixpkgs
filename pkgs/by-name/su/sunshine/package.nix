{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  autoAddDriverRunpath,
  makeWrapper,
  buildNpmPackage,
  nixosTests,
  cmake,
  avahi,
  libevdev,
  libpulseaudio,
  xorg,
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
  libappindicator,
  libnotify,
  miniupnpc,
  nlohmann_json,
  config,
  coreutils,
  udevCheckHook,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
}:
let
  stdenv' = if cudaSupport then cudaPackages.backendStdenv else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "sunshine";
  version = "2025.628.4510";

  src = fetchFromGitHub {
    owner = "LizardByte";
    repo = "Sunshine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xNWFo6a4YrJ+tBFTSReoAEi1oZ4DSguBEusizWeWKYY=";
    fetchSubmodules = true;
  };

  # build webui
  ui = buildNpmPackage {
    inherit (finalAttrs) src version;
    pname = "sunshine-ui";
    npmDepsHash = "sha256-kUixeLf8prsWQolg1v+vJ5rvwKZOsU+88+0hVOgTZ0A=";

    # use generated package-lock.json as upstream does not provide one
    postPatch = ''
      cp ${./package-lock.json} ./package-lock.json
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -a . "$out"/

      runHook postInstall
    '';
  };

  postPatch = # remove upstream dependency on systemd and udev
  ''
    substituteInPlace cmake/packaging/linux.cmake \
      --replace-fail 'find_package(Systemd)' "" \
      --replace-fail 'find_package(Udev)' ""
  ''
  # don't look for npm since we build webui separately
  + ''
    substituteInPlace cmake/targets/common.cmake \
      --replace-fail 'find_program(NPM npm REQUIRED)' ""

    substituteInPlace packaging/linux/dev.lizardbyte.app.Sunshine.desktop \
      --subst-var-by PROJECT_NAME 'Sunshine' \
      --subst-var-by PROJECT_DESCRIPTION 'Self-hosted game stream host for Moonlight' \
      --subst-var-by SUNSHINE_DESKTOP_ICON 'sunshine' \
      --subst-var-by CMAKE_INSTALL_FULL_DATAROOTDIR "$out/share" \
      --replace-fail '/usr/bin/env systemctl start --u sunshine' 'sunshine'

    substituteInPlace packaging/linux/sunshine.service.in \
      --subst-var-by PROJECT_DESCRIPTION 'Self-hosted game stream host for Moonlight' \
      --subst-var-by SUNSHINE_EXECUTABLE_PATH $out/bin/sunshine \
      --replace-fail '/bin/sleep' '${lib.getExe' coreutils "sleep"}'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    makeWrapper
    wayland-scanner
    # Avoid fighting upstream's usage of vendored ffmpeg libraries
    autoPatchelfHook
  ]
  ++ lib.optionals cudaSupport [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
    (lib.getDev cudaPackages.cuda_cudart)
  ];

  buildInputs = [
    avahi
    libevdev
    libpulseaudio
    xorg.libX11
    libxcb
    xorg.libXfixes
    xorg.libXrandr
    xorg.libXtst
    xorg.libXi
    openssl
    libopus
    boost
    libdrm
    wayland
    libffi
    libevdev
    libcap
    libdrm
    curl
    pcre
    pcre2
    libuuid
    libselinux
    libsepol
    libthai
    libdatrie
    xorg.libXdmcp
    libxkbcommon
    libepoxy
    libva
    libvdpau
    numactl
    libgbm
    amf-headers
    svt-av1
    libappindicator
    libnotify
    miniupnpc
    nlohmann_json
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cudatoolkit
    cudaPackages.cuda_cudart
  ];

  runtimeDependencies = [
    avahi
    libgbm
    xorg.libXrandr
    libxcb
    libglvnd
  ];

  cmakeFlags = [
    "-Wno-dev"
    # upstream tries to use systemd and udev packages to find these directories in FHS; set the paths explicitly instead
    (lib.cmakeBool "UDEV_FOUND" true)
    (lib.cmakeBool "SYSTEMD_FOUND" true)
    (lib.cmakeFeature "UDEV_RULES_INSTALL_DIR" "lib/udev/rules.d")
    (lib.cmakeFeature "SYSTEMD_USER_UNIT_INSTALL_DIR" "lib/systemd/user")
    (lib.cmakeBool "BOOST_USE_STATIC" false)
    (lib.cmakeBool "BUILD_DOCS" false)
    (lib.cmakeFeature "SUNSHINE_PUBLISHER_NAME" "nixpkgs")
    (lib.cmakeFeature "SUNSHINE_PUBLISHER_WEBSITE" "https://nixos.org")
    (lib.cmakeFeature "SUNSHINE_PUBLISHER_ISSUE_URL" "https://github.com/NixOS/nixpkgs/issues")
  ]
  ++ lib.optionals (!cudaSupport) [
    (lib.cmakeBool "SUNSHINE_ENABLE_CUDA" false)
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

  postInstall = ''
    install -Dm644 ../packaging/linux/dev.lizardbyte.app.Sunshine.desktop $out/share/applications/dev.lizardbyte.app.Sunshine.desktop
  '';

  # allow Sunshine to find libvulkan
  postFixup = lib.optionalString cudaSupport ''
    wrapProgram $out/bin/sunshine \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ udevCheckHook ];

  passthru = {
    tests.sunshine = nixosTests.sunshine;
    updateScript = ./updater.sh;
  };

  meta = {
    description = "Game stream host for Moonlight";
    homepage = "https://github.com/LizardByte/Sunshine";
    license = lib.licenses.gpl3Only;
    mainProgram = "sunshine";
    maintainers = with lib.maintainers; [ devusb ];
    platforms = lib.platforms.linux;
  };
})
