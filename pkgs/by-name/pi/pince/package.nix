{
  stdenv,
  lib,
  fetchFromGitHub,
  replaceVars,
  nix-update-script,

  rustPlatform,

  cmake,
  makeWrapper,

  python3Packages,
  python3,
  gdb,
  qt6,
  gtk3,
  gobject-introspection,
}:

let
  libptrscan = rustPlatform.buildRustPackage {
    pname = "libptrscan";
    version = "0.7.4-unstable-2024-09-13";

    src = fetchFromGitHub {
      owner = "kekeimiku";
      repo = "PointerSearcher-X";
      rev = "ba2b5eab4856aa4ffb3ece0bd2c7d0917fa4e6ce"; # last commit on pince_fix_32 branch
      hash = "sha256-skOM2dx+u7dYbWywaC8dtUuJuXzc4Mm6skBbMfaTwfY=";
    };

    cargoLock.lockFile = ./libptrscan/Cargo.lock;

    postPatch = ''
      cp ${./libptrscan/Cargo.lock} Cargo.lock;
      chmod +w Cargo.lock;
    '';

    cargoBuildFlags = [ "-p libptrscan" ];

    postInstall = ''
      install -Dm644 libptrscan/ptrscan.py -t "$out"/lib/
    '';
  };

  pythonEnv = python3.withPackages (
    ps: with ps; [
      capstone
      keyboard
      keystone-engine
      pexpect
      pygdbmi
      pygobject3
      pyqt6
    ]
  );

  gdb' = gdb.override {
    python3 = pythonEnv;
  };

  # LD_LIBRARY_PATH libraries
  LDPath = lib.makeLibraryPath [
    (lib.getLib stdenv.cc.cc)
    gtk3
    gdb'
  ];

  # GI_TYPELIB_PATH libraries
  GIPath = lib.makeSearchPath "lib/girepository-1.0" [
    gtk3
    gobject-introspection
  ];
in

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pince";
  version = "0.5";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "korcankaraokcu";
    repo = "PINCE";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D3IBzsY22GbqezFylvkT7ctthgK1vBgLaGG2Ahxj/fM=";
    fetchSubmodules = true;
  };

  build-system = with python3Packages; [
    setuptools
  ];

  nativeBuildInputs = [
    cmake
    gobject-introspection
    qt6.qttools
    qt6.wrapQtAppsHook
    makeWrapper
  ];

  buildInputs = [
    pythonEnv
    gdb'
    gobject-introspection
    qt6.qtbase
    qt6.qtwayland
    gtk3
  ];

  dontUseCmakeConfigure = true;

  postPatch = ''
    if [ "$(grep -c 'typedefs.PATHS.GDB' GUI/Settings/settings.py)" = "1" ]; then
      substituteInPlace GUI/Settings/settings.py \
        --replace-fail 'typedefs.PATHS.GDB' 'utils.get_default_gdb_path()';
    else
      echo "GUI/Settings/settings.py: expected 1 occurrence of typedefs.PATHS.GDB";
      exit 1;
    fi;

    if [ "$(grep -c 'not os.environ.get("APPDIR")' GUI/Widgets/Settings/Settings.py)" = "1" ]; then
      if [ "$(grep -c 'os.environ.get("APPDIR")' GUI/Widgets/Settings/Settings.py)" = "2" ]; then
        substituteInPlace GUI/Widgets/Settings/Settings.py \
          --replace-fail 'not os.environ.get("APPDIR")' 'False' \
          --replace-fail 'os.environ.get("APPDIR")' 'True';
      else
        echo "GUI/Widgets/Settings/Settings.py: expected 2 occurrences of os.environ.get(APPDIR)"
        exit 1;
      fi;
    else
      echo "GUI/Widgets/Settings/Settings.py: expected 1 occurrence of not os.environ.get(APPDIR)";
      exit 1;
    fi;

    if [ "$(grep -c 'os.environ.get("APPDIR")' PINCE.py)" = "3" ]; then
      substituteInPlace PINCE.py \
        --replace-fail 'os.environ.get("APPDIR")' 'True';
    else
      echo "PINCE.py: expected 3 occurrences of os.environ.get(APPDIR)";
      exit 1;
    fi;

    if [ "$(grep -c 'not os.environ.get("APPDIR")' libpince/debugcore.py)" = "1" ]; then
      substituteInPlace libpince/debugcore.py \
        --replace-fail 'not os.environ.get("APPDIR")' 'False';
    else
      echo "libpince/debugcore.py: expected 1 occurrence of not os.environ.get(APPDIR)";
      exit 1;
    fi;
    if [ "$(grep -c 'return appdir + "/usr/bin/gdb"' libpince/utils.py)" = "1" ]; then
      substituteInPlace libpince/utils.py \
        --replace-fail \
          'def get_default_gdb_path():
        appdir = os.environ.get("APPDIR")
        if appdir:
            return appdir + "/usr/bin/gdb"
        return typedefs.PATHS.GDB' \
          'def get_default_gdb_path():
        return "${lib.getExe gdb'}"';
    else
      echo "libpince/utils.py: expected 1 occurrence of get_default_gdb_path body";
      exit 1;
    fi;

    if [ "$(grep -c 'AppImage builds' tr/tr.py)" = "1" ]; then
      substituteInPlace tr/tr.py \
        --replace-fail 'AppImage builds' 'nixpkgs-based builds';
    else
      echo "tr/tr.py: expected 1 occurrence of AppImage builds";
      exit 1;
    fi;
  '';

  buildPhase = ''
    runHook preBuild

    # libscanmem
    pushd libscanmem-PINCE

    cmake -DCMAKE_BUILD_TYPE=Release .
    make -j$NIX_BUILD_CORES

    install -Dm555 libscanmem.so       -t ../libpince/libscanmem/
    install -Dm444 wrappers/scanmem.py -t ../libpince/libscanmem/
    popd

    # libptrscan
    install -Dm555 ${libptrscan}/lib/libptrscan.so -t libpince/libptrscan
    install -Dm444 ${libptrscan}/lib/ptrscan.py    -t libpince/libptrscan

    # Translations
    lrelease i18n/ts/*
    mkdir -p i18n/qm
    mv i18n/ts/*.qm i18n/qm/

    runHook postBuild
  '';

  makeWrapperArgs = [
    ''--chdir "$out/lib/pince"''
    ''--prefix LD_LIBRARY_PATH : "${LDPath}"''
    ''--prefix GI_TYPELIB_PATH : "${GIPath}"''
    ''--set PYTHONPATH "$out/lib/pince"''
    ''--set PYTHONDONTWRITEBYTECODE "1"''
    ''--add-flags "$out/lib/pince/PINCE.py"''
    ''--prefix PATH : "${lib.makeBinPath [ pythonEnv ]}"''
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/pince/
    cp -r GUI i18n libpince media tr AUTHORS COPYING COPYING.CC-BY PINCE.py THANKS $out/lib/pince/

    mkdir -p $out/bin
    ln -s $out/lib/pince/PINCE.py $out/bin/.pince-wrapped

    cat > $out/bin/pince << 'EOF'
    #!/usr/bin/env bash
    INNER="$(dirname -- "$(realpath -- "$0")")/.pince-wrapped";
    if type pkexec &> /dev/null; then
      ENV=();
      while IFS= read -r line; do
        ENV+=("$line");
      done < <(printenv);
      pkexec env "''${ENV[@]}" "$INNER";
    elif type sudo &> /dev/null; then
      sudo -E --preserve-env=PATH PYTHONDONTWRITEBYTECODE=1 "$INNER";
    else
      echo "No supported privilege escalation utility found.";
      exit 1;
    fi;
    EOF

    chmod +x $out/bin/pince;

    runHook postInstall
  '';

  postFixup = ''
    makeWrapperArgs="$makeWrapperArgs ''${qtWrapperArgs[*]}"
    wrapPythonProgramsIn "$out/lib/pince" "$out ''${pythonPath[*]}"
    patchShebangs --build $out/bin/pince;
  '';

  passthru = {
    inherit libptrscan;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Reverse engineering tool for games (Linux alternative to Cheat Engine)";
    homepage = "https://github.com/korcankaraokcu/PINCE";
    mainProgram = "pince";
    license = with lib.licenses; [
      gpl3Plus
      cc-by-30
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ yuannan ];
  };
})
