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
  mesa,
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
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
}:
let
  stdenv' = if cudaSupport then cudaPackages.backendStdenv else stdenv;
in
stdenv'.mkDerivation rec {
  pname = "sunshine";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "LizardByte";
    repo = "Sunshine";
    rev = "v${version}";
    hash = "sha256-D5ee5m2ZTKVqZDH07nzJuFEbZBQ4xW7m4nYnJQe0EaA=";
    fetchSubmodules = true;
  };

  patches = [
    # fix(upnp): support newer miniupnpc library (#2782)
    # Manually cherry-picked on to 0.23.1.
    ./0001-fix-upnp-support-newer-miniupnpc-library-2782.patch
  ];

  # build webui
  ui = buildNpmPackage {
    inherit src version;
    pname = "sunshine-ui";
    npmDepsHash = "sha256-9FuMtxTwrU9UIhZXQn/tmGN0IHZBdunV0cY/EElj4bA=";

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
      mesa
      amf-headers
      svt-av1
      libappindicator
      libnotify
      miniupnpc
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cudatoolkit
    ]
    ++ lib.optionals stdenv.hostPlatform.isx86_64 [
      intel-media-sdk
    ];

  runtimeDependencies = [
    avahi
    mesa
    xorg.libXrandr
    libxcb
    libglvnd
  ];

  cmakeFlags = [
    "-Wno-dev"
    # upstream tries to use systemd and udev packages to find these directories in FHS; set the paths explicitly instead
    (lib.cmakeFeature "UDEV_RULES_INSTALL_DIR" "lib/udev/rules.d")
    (lib.cmakeFeature "SYSTEMD_USER_UNIT_INSTALL_DIR" "lib/systemd/user")
  ];

  postPatch = ''
    # remove upstream dependency on systemd and udev
    substituteInPlace cmake/packaging/linux.cmake \
      --replace-fail 'find_package(Systemd)' "" \
      --replace-fail 'find_package(Udev)' ""

    substituteInPlace packaging/linux/sunshine.desktop \
      --subst-var-by PROJECT_NAME 'Sunshine' \
      --subst-var-by PROJECT_DESCRIPTION 'Self-hosted game stream host for Moonlight' \
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
