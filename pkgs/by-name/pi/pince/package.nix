{
  lib,
  stdenv,
  fetchFromGitHub,
  bashNonInteractive,
  copyDesktopItems,
  coreutils,
  gdb,
  makeDesktopItem,
  nix-update-script,
  python3,
  qt6,
  zig_0_16,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      capstone
      keyboard
      keystone-engine
      msgpack
      pexpect
      pygdbmi
      pyqt6
    ]
  );

  gdb' = gdb.override {
    python3 = pythonEnv;
  };

  LDPath = lib.makeLibraryPath [
    (lib.getLib stdenv.cc.cc)
    gdb'
  ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "pince";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "korcankaraokcu";
    repo = "PINCE";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tx1rQdbQo/xCwr25Io54o1tOBdwvWFK79EPOvErn5I8=";
    fetchSubmodules = true;
  };

  __structuredAttrs = true;
  strictDeps = true;

  postPatch = ''
    substituteInPlace libpince/typedefs.py \
      --replace-fail '"/bin/gdb"' '"${lib.getExe gdb'}"'
    substituteInPlace libpince/debugcore.py \
      --replace-fail 'if not os.environ.get("APPDIR"):' 'if False:'
    substituteInPlace GUI/Settings/settings.py \
      --replace-fail 'settings.value("Debug/gdb_path", type=str)' 'typedefs.PATHS.GDB'
    substituteInPlace PINCE.sh \
      --replace-fail 'SCRIPTDIR=$(cd -- "$(dirname -- "$0")" && pwd -P)' "" \
      --replace-fail 'if [ ! -d "''${SCRIPTDIR}/.venv/bin" ]; then' 'if false; then' \
      --replace-fail '. "''${SCRIPTDIR}/.venv/bin/activate"' "" \
      --replace-fail 'PYTHON="''${SCRIPTDIR}/.venv/bin/python3"' "" \
      --replace-fail 'PINCE_PY="''${SCRIPTDIR}/PINCE.py"' "" \
      --replace-fail '"$PYTHON" "$PINCE_PY"' "$out/libexec/pince" \
      --replace-fail 'agent env "$@"' 'agent ${lib.getExe' coreutils "env"} -u LC_ALL "$@"'
  '';

  nativeBuildInputs = [
    copyDesktopItems
    qt6.qttools
    qt6.wrapQtAppsHook
    zig_0_16
  ];

  buildInputs = [
    bashNonInteractive
    pythonEnv
    qt6.qtbase
    qt6.qtwayland
  ];

  dontWrapQtApps = true;

  buildPhase = ''
    runHook preBuild

    zigFlags=(-j"$NIX_BUILD_CORES" "$zigDefaultCpuFlag" -Doptimize=ReleaseFast)

    pushd libmemscan
    zig build "''${zigFlags[@]}"
    install -Dm555 zig-out/lib/libmemscan.so -t ../libpince/libmemscan/
    install -Dm444 memscan.py -t ../libpince/libmemscan/
    popd

    pushd mono_collector
    for arch in x86_64:x64 x86:x86; do
      zig build "''${zigFlags[@]}" -Dtarget=''${arch%:*}-linux-gnu
      install -Dm444 zig-out/lib/libmono_collector.so ../libpince/libmono_collector/mono_collector_''${arch#*:}.so
      zig build "''${zigFlags[@]}" -Dtarget=''${arch%:*}-windows-gnu
      install -Dm444 zig-out/bin/mono_collector.dll ../libpince/libmono_collector/mono_collector_wine_''${arch#*:}.dll
    done
    popd

    lrelease i18n/ts/*
    mkdir -p i18n/qm
    mv i18n/ts/*.qm i18n/qm/

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 AUTHORS COPYING COPYING.CC-BY PINCE.py THANKS -t $out/lib/pince
    cp -r GUI i18n libpince media tr $out/lib/pince/

    install -Dm644 media/logo/ozgurozbek/pince_appimage.png \
      $out/share/icons/hicolor/512x512/apps/PINCE.png

    install -Dm755 PINCE.sh $out/bin/pince

    runHook postInstall
  '';

  preFixup = ''
    makeQtWrapper ${pythonEnv.interpreter} $out/libexec/pince \
      --chdir $out/lib/pince \
      --set PYTHONPATH $out/lib/pince \
      --set PYTHONNOUSERSITE true \
      --prefix LD_LIBRARY_PATH : ${LDPath} \
      --prefix PATH : ${lib.makeBinPath [ pythonEnv ]} \
      --add-flags $out/lib/pince/PINCE.py
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "io.github.korcankaraokcu.PINCE";
      desktopName = "PINCE";
      exec = "pince";
      icon = "PINCE";
      categories = [
        "Development"
        "Debugger"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Reverse engineering tool for games (Linux alternative to Cheat Engine)";
    homepage = "https://github.com/korcankaraokcu/PINCE";
    license = with lib.licenses; [
      gpl3Plus
      cc-by-30
    ];
    maintainers = with lib.maintainers; [
      mtrsk
      yuannan
    ];
    platforms = lib.platforms.linux;
    mainProgram = "pince";
  };
})
