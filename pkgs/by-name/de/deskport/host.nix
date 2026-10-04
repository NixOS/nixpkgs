# Adapted from Nixpkgs sunshine at 93108a538f079596c9a16c72cf03e9322782b6dd (MIT).
{
  deskportSource,
  deskportVersion,
  runCommand,
  callPackage,
  vulkan-headers,
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  git,
  buildNpmPackage,
  cmake,
  avahi,
  libevdev,
  libpulseaudio,
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
  shaderc,
  vulkan-loader,
  libappindicator,
  libnotify,
  pipewire,
  miniupnpc,
  nlohmann_json,
  coreutils,
  udevCheckHook,
}:
let
  # Match the FFmpeg ABI used by DeskPort 0.6.3's vendored host.
  originalFFmpeg = fetchzip {
    url = "https://github.com/LizardByte/build-deps/releases/download/v2026.516.30821/Linux-x86_64-ffmpeg.tar.gz";
    hash = "sha256-VT+4qP2FaizCoIBBbBkzbYw4YOvGhuBUoZxWL0IYVZo=";
  };
  ffmpegPrebuilt = callPackage ./ffmpeg.nix {
    prebuilt = originalFFmpeg;
    inherit deskportSource;
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "deskport-host";
  version = deskportVersion;

  src = runCommand "deskport-host-source-${deskportVersion}" { } ''
    mkdir -p "$out"
    tar -xzf ${deskportSource}/host/vendor/sunshine-nix.tar.gz --strip-components=1 -C "$out"
  '';

  # build webui
  ui = buildNpmPackage {
    inherit (finalAttrs) src version;
    pname = "sunshine-ui";
    npmDepsHash = "sha256-YnNnuAdj/S5LGNytqIsmCApIec8DTWKF6VIJ7AXUctU=";

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

  postPatch = # don't look for npm since we build webui separately
  ''
    substituteInPlace cmake/targets/common.cmake \
      --replace-fail 'find_program(NPM npm REQUIRED)' ""
  ''
  # use system boost instead of FetchContent.
  # FETCH_CONTENT_BOOST_USED prevents Simple-Web-Server from re-finding boost
  + ''
    sed -i -E 's/set\(BOOST_VERSION "[^"]*"\)/set(BOOST_VERSION "${boost.version}")/' \
      cmake/dependencies/Boost_Sunshine.cmake
    echo 'set(FETCH_CONTENT_BOOST_USED TRUE)' >> cmake/dependencies/Boost_Sunshine.cmake
  ''
  # remove upstream dependency on systemd and udev
  + ''
    substituteInPlace cmake/packaging/linux.cmake \
      --replace-fail 'find_package(Systemd)' "" \
      --replace-fail 'find_package(Udev)' ""

    # The remaining @VAR@ placeholders in the .desktop file (PROJECT_NAME,
    # PROJECT_DESCRIPTION, PROJECT_FQDN, SUNSHINE_DESKTOP_ICON,
    # CMAKE_INSTALL_FULL_DATAROOTDIR) are substituted by cmake's
    # configure_file(... @ONLY) during the build.
    substituteInPlace packaging/linux/dev.lizardbyte.app.Sunshine.desktop \
      --replace-fail '/usr/bin/env systemctl start --u app-@PROJECT_FQDN@' 'sunshine'

    substituteInPlace packaging/linux/app-dev.lizardbyte.app.Sunshine.service.in \
      --replace-fail '/bin/sleep' '${lib.getExe' coreutils "sleep"}'
  ''
  + ''
    python3 ${deskportSource}/scripts/patch-host-diagnostics.py .
    python3 ${deskportSource}/scripts/patch-host-network.py .
    python3 ${deskportSource}/scripts/patch-host-smart-stream.py .
    python3 ${deskportSource}/scripts/patch-host-session-settings.py .
    python3 ${deskportSource}/scripts/patch-host-session-takeover.py .
    python3 ${deskportSource}/scripts/patch-host-linux-display.py .
    mkdir -p src/deskport/common
    cp ${deskportSource}/host/common/smartstream.h src/deskport/common/smartstream.h
    cp ${deskportSource}/host/common/inputactivity.h src/deskport/common/inputactivity.h
    cp ${deskportSource}/host/common/framecadence.h src/deskport/common/framecadence.h
    python3 ${deskportSource}/scripts/patch-host-input-activity.py .
    python3 ${deskportSource}/scripts/patch-host-sync-cadence.py .
    python3 ${deskportSource}/scripts/patch-host-linux-cadence.py .
    python3 ${deskportSource}/scripts/patch-host-pipewire-memory.py .
    python3 ${deskportSource}/scripts/patch-host-display-ownership.py .
    python3 ${deskportSource}/scripts/patch-host-egl-query-lifetime.py .
    python3 ${deskportSource}/scripts/patch-host-vulkan-lifetime.py . ${deskportSource}/host/linux/vulkan-driver-lifetime.h
    python3 ${deskportSource}/scripts/patch-host-memory-diagnostics.py . ${deskportSource}/host/common/memorydiagnostics.h
    cp ${deskportSource}/host/common/encoderpolicy.h src/deskport/common/encoderpolicy.h
    python3 ${deskportSource}/scripts/patch-host-encoder-policy.py .
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    # glad's generator needs Jinja2 + setuptools at configure time;
    # GLAD_SKIP_PIP_INSTALL=ON tells cmake not to pip-install them.
    (python3.withPackages (ps: [
      ps.jinja2
      ps.setuptools
    ]))
    makeWrapper
    python3
    git
  ]
  ++ [
    wayland-scanner
    shaderc # provides glslc, needed at configure time for shader compilation
    # Avoid fighting upstream's usage of vendored ffmpeg libraries
    autoPatchelfHook
  ];

  buildInputs = [
    vulkan-headers
    boost
    curl
    miniupnpc
    nlohmann_json
    openssl
    libopus
  ]
  ++ [
    avahi
    libevdev
    libpulseaudio
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
    pipewire
    libappindicator
    libnotify
  ];

  runtimeDependencies = [
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
    # avoid cmake's network download of the LizardByte/build-deps ffmpeg tarball
    (lib.cmakeFeature "FFMPEG_PREPARED_BINARIES" "${ffmpegPrebuilt}")
    # we provide Jinja2/setuptools via python3.withPackages; don't pip-install
    (lib.cmakeBool "GLAD_SKIP_PIP_INSTALL" true)
  ]
  # upstream tries to use systemd and udev packages to find these directories in FHS; set the paths explicitly instead
  ++ [
    (lib.cmakeBool "UDEV_FOUND" true)
    (lib.cmakeBool "SYSTEMD_FOUND" true)
    (lib.cmakeFeature "UDEV_RULES_INSTALL_DIR" "lib/udev/rules.d")
    (lib.cmakeFeature "SYSTEMD_USER_UNIT_INSTALL_DIR" "lib/systemd/user")
    (lib.cmakeFeature "SYSTEMD_MODULES_LOAD_DIR" "lib/modules-load.d")
    # used in the generated systemd unit's ExecStart= line
    (lib.cmakeFeature "SUNSHINE_EXECUTABLE_PATH" "${placeholder "out"}/bin/sunshine")
  ]
  ++ [ (lib.cmakeBool "SUNSHINE_ENABLE_CUDA" false) ];

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

  doInstallCheck = true;
  nativeInstallCheckInputs = [ udevCheckHook ];

  meta = {
    description = "Private session host for DeskPort";
    homepage = "https://github.com/keithxc/deskport";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "sunshine";
  };
})
