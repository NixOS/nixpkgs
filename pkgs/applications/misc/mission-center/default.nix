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
    rev = "9a8458b541a195a0c5cadafb66e240962c852b39";
    hash = "sha256-iFBZbESRTuwgLSUuHnjcXwmpvdeQrd3oUJd7BRyxu84=";
  };
in
stdenv.mkDerivation rec {
  pname = "mission-center";
  version = "0.2.5";

  src = fetchFromGitLab {
    owner = "mission-center-devs";
    repo = "mission-center";
    rev = "v${version}";
    hash = "sha256-f6GkwF+3USl60pUxxTu90KzdsfxBiAkiqnBSTTmC2Lc=";
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
        lockFile = ./proxy-Cargo.lock;
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
    echo -e "[wrap-file]\ndirectory = nvtop-src\n[provide]\ndependency_names = nvtop" > ./subprojects/nvtop.wrap
    cp -r --no-preserve=mode,ownership "${nvtop}" ./subprojects/nvtop-src
    cd ./subprojects/nvtop-src
    mkdir -p include/libdrm
    for patchfile in $(ls ../packagefiles/nvtop*.patch); do
      patch -p1 < $patchfile
    done
    cd ../..
    patchShebangs data/hwdb/generate_hwdb.py
    sed -i 's|cmd.arg("dmidecode")|cmd.arg("${dmidecode}/bin/dmidecode")|g' src/sys_info_v2/mem_info.rs
  '';

  meta = with lib; {
    description = "Monitor your CPU, Memory, Disk, Network and GPU usage";
    homepage = "https://gitlab.com/mission-center-devs/mission-center";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ GaetanLepage ];
    platforms = platforms.linux;
  };
}
