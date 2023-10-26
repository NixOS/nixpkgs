{ lib
, stdenv
, fetchFromGitLab
, fetchFromGitHub
, cargo
, libxml2
, meson
, ninja
, pkg-config
, python311
, rustPlatform
, symlinkJoin
, rustc
, wrapGAppsHook4
, appstream-glib
, blueprint-compiler
, cairo
, cmake
, desktop-file-utils
, dmidecode
, gdk-pixbuf
, gettext
, glib
, graphene
, gtk4
, libadwaita
, libdrm
, mesa
, pango
, sqlite
, udev
, wayland
}:

let
  nvtop = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    rev = "be47f8c560487efc6e6a419d59c69bfbdb819324";
    hash = "sha256-MdaZYLxCuVX4LvbwBYNfHHoJWqZAy4J8NBK7Guh2whc=";
  };
in
stdenv.mkDerivation rec {
  pname = "mission-center";
  version = "0.3.3";

  src = fetchFromGitLab {
    owner = "mission-center-devs";
    repo = "mission-center";
    rev = "v${version}";
    hash = "sha256-xLyCLKUk21MvswtPUKm41Hr34vTzCMVQNTaAkuhSGLc=";
  };

  cargoDeps = symlinkJoin {
    name = "cargo-vendor-dir";
    paths = [
      (rustPlatform.importCargoLock {
        lockFile = ./Cargo.lock;
        outputHashes = {
          "pathfinder_canvas-0.5.0" = "sha256-k2Sj69hWA0UzRfv91aG1TAygVIuOX3gmipcDbuZxxc8=";
        };
      })
      (rustPlatform.importCargoLock {
        lockFile = ./gatherer-Cargo.lock;
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
    desktop-file-utils
    dmidecode
    gdk-pixbuf
    gettext
    glib
    graphene
    gtk4
    libadwaita
    libdrm
    mesa
    pango
    sqlite
    udev
    wayland
  ];

  postPatch = ''
    SRC_GATHERER=$NIX_BUILD_TOP/source/src/sys_info_v2/gatherer
    SRC_GATHERER_NVTOP=$SRC_GATHERER/3rdparty/nvtop

    substituteInPlace $SRC_GATHERER_NVTOP/nvtop.json \
      --replace "nvtop-be47f8c560487efc6e6a419d59c69bfbdb819324" "nvtop-src"

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

  postInstall = ''
    wrapProgram $out/bin/missioncenter --prefix PATH : $out/bin:${dmidecode}/bin
  '';

  meta = with lib; {
    description = "Monitor your CPU, Memory, Disk, Network and GPU usage";
    homepage = "https://gitlab.com/mission-center-devs/mission-center";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ GaetanLepage ];
    platforms = platforms.linux;
    mainProgram = "missioncenter";
  };
}
