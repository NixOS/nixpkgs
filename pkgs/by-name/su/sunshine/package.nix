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
  intel-media-sdk,
  svt-av1,
  vulkan-loader,
  libappindicator,
  libnotify,
  miniupnpc,
  nlohmann_json,
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
}:
let
  stdenv' = if cudaSupport then cudaPackages.backendStdenv else stdenv;
in
stdenv'.mkDerivation rec {
  pname = "sunshine";
  version = "2025.122.141614";

  src = fetchFromGitHub {
    owner = "LizardByte";
    repo = "Sunshine";
    tag = "v${version}";
    hash = "sha256-rHf+lj5dycXA//fu3RPuimYz2hrJnoVt7GA2xuHGXJk=";
    fetchSubmodules = true;
  };

  # build webui
  ui = buildNpmPackage {
    inherit src version;
    pname = "sunshine-ui";
    npmDepsHash = "sha256-sWCmx1dMEyRyuYeeuqAjHZLVnckskgQO4saFM64s4Y4=";

    # use generated package-lock.json as upstream does not provide one
    postPatch = ''
      cp ${./package-lock.json} ./package-lock.json
    '';

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
  };

  nativeBuildInputs =
    [
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
    ];

  buildInputs =
    [
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
    ]
    ++ lib.optionals stdenv.hostPlatform.isx86_64 [
      intel-media-sdk
    ];

  runtimeDependencies = [
    avahi
    libgbm
    xorg.libXrandr
    libxcb
    libglvnd
  ];

  cmakeFlags =
    [
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
    BUILD_VERSION = "${version}";
    BRANCH = "master";
    COMMIT = "";
  };

  postPatch = ''
    # remove upstream dependency on systemd and udev
    substituteInPlace cmake/packaging/linux.cmake \
      --replace-fail 'find_package(Systemd)' "" \
      --replace-fail 'find_package(Udev)' ""

    # don't look for npm since we build webui separately
    substituteInPlace cmake/targets/common.cmake \
      --replace-fail 'find_program(NPM npm REQUIRED)' ""

    substituteInPlace packaging/linux/sunshine.desktop \
      --subst-var-by PROJECT_NAME 'Sunshine' \
      --subst-var-by PROJECT_DESCRIPTION 'Self-hosted game stream host for Moonlight' \
      --subst-var-by SUNSHINE_DESKTOP_ICON 'sunshine' \
      --subst-var-by CMAKE_INSTALL_FULL_DATAROOTDIR "$out/share" \
      --replace-fail '/usr/bin/env systemctl start --u sunshine' 'sunshine'

    substituteInPlace packaging/linux/sunshine.service.in \
      --subst-var-by PROJECT_DESCRIPTION 'Self-hosted game stream host for Moonlight' \
      --subst-var-by SUNSHINE_EXECUTABLE_PATH $out/bin/sunshine
  '';

  preBuild = ''
    # copy webui where it can be picked up by build
    cp -r ${ui}/build ../
  '';

  buildFlags = [
    "sunshine"
  ];

  # allow Sunshine to find libvulkan
  postFixup = lib.optionalString cudaSupport ''
    wrapProgram $out/bin/sunshine \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  # redefine installPhase to avoid attempt to build webui
  installPhase = ''
    runHook preInstall
    cmake --install .
    runHook postInstall
  '';

  postInstall = ''
    install -Dm644 ../packaging/linux/${pname}.desktop $out/share/applications/${pname}.desktop
  '';

  passthru = {
    tests.sunshine = nixosTests.sunshine;
    updateScript = ./updater.sh;
  };

  meta = with lib; {
    description = "Sunshine is a Game stream host for Moonlight";
    homepage = "https://github.com/LizardByte/Sunshine";
    license = licenses.gpl3Only;
    mainProgram = "sunshine";
    maintainers = with maintainers; [ devusb ];
    platforms = platforms.linux;
  };
}
