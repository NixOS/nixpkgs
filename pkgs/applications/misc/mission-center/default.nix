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
  version = "0.3.2";

  src = fetchFromGitLab {
    owner = "mission-center-devs";
    repo = "mission-center";
    rev = "v${version}";
    hash = "sha256-KuaVivW/i+1Pw6ShpvBYbwPMUHsEJ7FR80is0DBMbXM=";
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
    echo -e "[wrap-file]\ndirectory = nvtop-src\n[provide]\ndependency_names = nvtop" > ./subprojects/nvtop.wrap
    cp -r --no-preserve=mode,ownership "${nvtop}" ./subprojects/nvtop-src
    cd ./subprojects/nvtop-src
    mkdir -p include/libdrm
    for patchfile in $(ls ../packagefiles/nvtop*.patch); do
      patch -p1 < $patchfile
    done
    cd ../..
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
