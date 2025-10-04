{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  replaceVars,

  cmake,
  qt6,
  wrapGAppsHook3,

  python3,
  gdb,
  gtk3,
  gobject-introspection,
}:

let
  python = python3.withPackages (
    ps: with ps; [
      pyqt6
      pexpect
      capstone
      keystone-engine
      pygdbmi
      keyboard
      pygobject3
    ]
  );

  gdb' = gdb.override {
    python3 = python;
  };

  libptrscan = rustPlatform.buildRustPackage {
    pname = "libptrscan";
    version = "0.7.4-unstable-2024-09-13";

    src = fetchFromGitHub {
      owner = "kekeimiku";
      repo = "PointerSearcher-X";
      rev = "ba2b5eab4856aa4ffb3ece0bd2c7d0917fa4e6ce"; # last commit on pince_fix_32 branch
      hash = "sha256-skOM2dx+u7dYbWywaC8dtUuJuXzc4Mm6skBbMfaTwfY=";
    };

    cargoPatches = [ ./libptrscan-add-cargo-lock.patch ];

    cargoHash = "sha256-YhpiOvODsyVnh6ukEVcQwAF3eYT/DbZmtq5+MIcJrtY=";

    cargoBuildFlags = [ "-p libptrscan" ];

    postInstall = ''
      install -Dm644 libptrscan/ptrscan.py -t "$out"/lib/
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "pince";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "korcankaraokcu";
    repo = "PINCE";
    rev = "v${version}";
    hash = "sha256-hGPENzcMbXTRZ57wxTDIGPK9dDvjKVeGwhgGX6fB25I=";
    fetchSubmodules = true;
  };

  patches = [
    (replaceVars ./set-gdb-path.patch {
      gdb_exe_path = lib.getExe gdb';
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
    wrapGAppsHook3
  ];

  buildInputs = [
    qt6.qtbase
    gobject-introspection
  ];

  dontWrapGApps = true;
  dontWrapQtApps = true;
  dontUseCmakeConfigure = true;

  # mostly taken from install.sh
  buildPhase = ''
    runHook preBuild

    pushd libscanmem-PINCE
    cmake -DCMAKE_BUILD_TYPE=Release .
    make -j"$NIX_BUILD_CORES"
    install -Dm755 libscanmem.so -t ../libpince/libscanmem
    install -Dm644 wrappers/scanmem.py -t ../libpince/libscanmem
    popd

    install -Dm755 ${libptrscan}/lib/libptrscan.so -t libpince/libptrscan/
    install -Dm644 ${libptrscan}/lib/ptrscan.py -t libpince/libptrscan/

    lrelease i18n/ts/*
    mkdir -p i18n/qm
    mv i18n/ts/*.qm i18n/qm/

    runHook postBuild
  '';

  # mostly taken from ci/package.sh
  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/share/pince
    cp -r GUI i18n libpince media tr AUTHORS COPYING COPYING.CC-BY PINCE.py THANKS "$out"/share/pince/

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${lib.getExe python} "$out"/bin/PINCE \
      --add-flags "$out"/share/pince/PINCE.py \
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}" \
      --prefix GI_TYPELIB_PATH : ${lib.getLib gtk3}/lib/girepository-1.0
      # ^ not sure why this isn't automatically added by wrapGAppsHook
  '';

  passthru = {
    inherit libptrscan;
  };

  meta = {
    description = "Reverse engineering tool for linux games";
    homepage = "https://github.com/korcankaraokcu/PINCE";
    license = with lib.licenses; [
      gpl3Only
      cc-by-30
    ];
    maintainers = with lib.maintainers; [ tomasajt ];
    mainProgram = "PINCE";
    platforms = lib.platforms.linux;
  };
}
