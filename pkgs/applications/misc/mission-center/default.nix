{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchFromGitHub,
  cargo,
  libxml2,
  meson,
  ninja,
  pkg-config,
  python311,
  rustPlatform,
  symlinkJoin,
  rustc,
  wrapGAppsHook4,
  appstream-glib,
  blueprint-compiler,
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
  dmidecode,
  vulkan-loader,
}:

let
  nvtop = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    rev = "45a1796375cd617d16167869bb88e5e69c809468";
    hash = "sha256-1P9pWXhgTHogO0DztxOsFKNwvTRRfDL3nzGmMANMC9w=";
  };
in
stdenv.mkDerivation rec {
  pname = "mission-center";
  version = "0.5.2";

  src = fetchFromGitLab {
    owner = "mission-center-devs";
    repo = "mission-center";
    rev = "v${version}";
    hash = "sha256-84D+CttolY5hleCJbDiN3mlk0+nlwwJUJhGoKGVT/lw=";
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
    python311
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
      --replace '"missioncenter-gatherer"' '"${placeholder "out"}/bin/missioncenter-gatherer"'

    substituteInPlace src/sys_info_v2/mem_info.rs \
      --replace '"dmidecode"' '"${dmidecode}/bin/dmidecode"'

    substituteInPlace $cargoDepsCopy/gl_loader-*/src/glad.c \
      --replace "libGL.so.1" "${libGL}/lib/libGL.so.1"

    substituteInPlace $cargoDepsCopy/ash-*/src/entry.rs \
      --replace '"libvulkan.so.1"' '"${vulkan-loader}/lib/libvulkan.so.1"'

    SRC_GATHERER=$NIX_BUILD_TOP/source/src/sys_info_v2/gatherer
    SRC_GATHERER_NVTOP=$SRC_GATHERER/3rdparty/nvtop

    substituteInPlace $SRC_GATHERER_NVTOP/nvtop.json \
      --replace "nvtop-45a1796375cd617d16167869bb88e5e69c809468" "nvtop-src"

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
