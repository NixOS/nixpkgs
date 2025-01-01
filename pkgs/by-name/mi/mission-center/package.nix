{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  rustPlatform,
  symlinkJoin,

  # nativeBuildInputs
  blueprint-compiler,
  cargo,
  libxml2,
  meson,
  ninja,
  pkg-config,
  python3,
  rustc,
  wrapGAppsHook4,

  # buildInputs
  appstream-glib,
  cairo,
  cmake,
  dbus,
  desktop-file-utils,
  gdk-pixbuf,
  gettext,
  glib,
  graphene,
  gtk4,
  libGL,
  libadwaita,
  libdrm,
  mesa,
  pango,
  sqlite,
  udev,
  wayland,

  vulkan-loader,
}:

let
  nvtop = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    rev = "20ea55dbd1eeb4342ff0112fae3ee2a0bfe352ea";
    hash = "sha256-8lNvxmNAqkmBPFeiYIGtpW0hYXA9N0l4HURew5loj+g=";
  };
in
stdenv.mkDerivation rec {
  pname = "mission-center";
  version = "0.6.0";

  src = fetchFromGitLab {
    owner = "mission-center-devs";
    repo = "mission-center";
    rev = "v${version}";
    hash = "sha256-MHCQHQFMd+YFgwY+k5iVZG08UeYBvEhrZGhHmzR+cLc=";
  };

  cargoDeps = symlinkJoin {
    name = "cargo-vendor-dir";
    paths = [
      (rustPlatform.importCargoLock { lockFile = ./Cargo.lock; })
      (rustPlatform.importCargoLock { lockFile = ./gatherer-Cargo.lock; })
    ];
  };

  nativeBuildInputs = [
    blueprint-compiler
    cargo
    libxml2
    meson
    ninja
    pkg-config
    python3
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    appstream-glib
    blueprint-compiler
    cairo
    cmake
    dbus
    desktop-file-utils
    gdk-pixbuf
    gettext
    glib
    graphene
    gtk4
    libGL
    libadwaita
    libdrm
    mesa
    pango
    sqlite
    udev
    wayland
  ];

  postPatch = ''
    substituteInPlace src/sys_info_v2/gatherer.rs \
      --replace-fail '"missioncenter-gatherer"' '"${placeholder "out"}/bin/missioncenter-gatherer"'

    substituteInPlace $cargoDepsCopy/gl_loader-*/src/glad.c \
      --replace-fail "libGL.so.1" "${libGL}/lib/libGL.so.1"

    substituteInPlace $cargoDepsCopy/ash-*/src/entry.rs \
      --replace-fail '"libvulkan.so.1"' '"${vulkan-loader}/lib/libvulkan.so.1"'

    SRC_GATHERER=$NIX_BUILD_TOP/source/src/sys_info_v2/gatherer
    SRC_GATHERER_NVTOP=$SRC_GATHERER/3rdparty/nvtop

    substituteInPlace $SRC_GATHERER_NVTOP/nvtop.json \
      --replace-fail "nvtop-${nvtop.rev}" "nvtop-src"

    GATHERER_BUILD_DEST=$NIX_BUILD_TOP/source/build/src/sys_info_v2/gatherer/src/debug/build/native
    mkdir -p $GATHERER_BUILD_DEST
    NVTOP_SRC=$GATHERER_BUILD_DEST/nvtop-src

    cp -r --no-preserve=mode,ownership "${nvtop}" $NVTOP_SRC
    pushd $NVTOP_SRC
    mkdir -p include/libdrm
    for patchfile in $(ls $SRC_GATHERER_NVTOP/patches/nvtop*.patch); do
      patch -p1 < $patchfile
    done
    popd

    patchShebangs data/hwdb/generate_hwdb.py
  '';

  meta = {
    description = "Monitor your CPU, Memory, Disk, Network and GPU usage";
    homepage = "https://gitlab.com/mission-center-devs/mission-center";
    changelog = "https://gitlab.com/mission-center-devs/mission-center/-/releases/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
    mainProgram = "missioncenter";
  };
}
