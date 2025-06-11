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
  libgbm,
  pango,
  sqlite,
  udev,
  vulkan-loader,
  wayland,

  versionCheckHook,
}:

# UPDATE PROCESS:
# 1) Get the nvtop commit hash (`source-url` in `nvtop.json`):
#     https://gitlab.com/mission-center-devs/mission-center/-/blob/v<VERSION>/src/sys_info_v2/gatherer/3rdparty/nvtop/nvtop.json?ref_type=tags
# 2) Update the version of the main derivation
# 3) Refresh all hashes:
#   - main `src`
#   - `nvtop` (if needed)
#   - **both** CargoDeps hashes

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
  version = "0.6.2";

  src = fetchFromGitLab {
    owner = "mission-center-devs";
    repo = "mission-center";
    rev = "v${version}";
    hash = "sha256-PvHIvWyhGovlLaeHk2WMp3yRz4VxvvINzX1oqkFgVuQ=";
  };

  cargoDeps = symlinkJoin {
    name = "cargo-vendor-dir";
    paths = [
      (rustPlatform.fetchCargoVendor {
        inherit pname version src;
        hash = "sha256-Yd6PlsSo8/yHMF4YdYz1Io4uGniAMyIj2RKy3yK4byU=";
      })
      (rustPlatform.fetchCargoVendor {
        inherit pname version src;
        sourceRoot = "${src.name}/src/sys_info_v2/gatherer";
        hash = "sha256-oUAPJWNElj08jfmsdXz/o2bgzeBQsbm6nWHC8jGN2n0=";
      })
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
    libgbm
    pango
    sqlite
    udev
    vulkan-loader
    wayland
  ];

  postPatch = ''
    substituteInPlace src/sys_info_v2/gatherer.rs \
      --replace-fail '"missioncenter-gatherer"' '"${placeholder "out"}/bin/missioncenter-gatherer"'

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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${builtins.placeholder "out"}/bin/${meta.mainProgram}";
  doInstallCheck = true;

  env = {
    # Make sure libGL and libvulkan can be found by dlopen()
    RUSTFLAGS = toString (
      map (flag: "-C link-arg=" + flag) [
        "-Wl,--push-state,--no-as-needed"
        "-lGL"
        "-lvulkan"
        "-Wl,--pop-state"
      ]
    );
  };

  meta = {
    description = "Monitor your CPU, Memory, Disk, Network and GPU usage";
    homepage = "https://gitlab.com/mission-center-devs/mission-center";
    changelog = "https://gitlab.com/mission-center-devs/mission-center/-/releases/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      GaetanLepage
      getchoo
    ];
    platforms = lib.platforms.linux;
    mainProgram = "missioncenter";
  };
}
