{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,

  zig,
  makeWrapper,
  makeDesktopItem,

  python3Packages,
  python3,
  gdb,
  qt6,
  gtk3,
  gobject-introspection,

  coreutils,
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
  version = "0.10.2";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "korcankaraokcu";
    repo = "PINCE";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tx1rQdbQo/xCwr25Io54o1tOBdwvWFK79EPOvErn5I8=";
    fetchSubmodules = true;
  };

  build-system = with python3Packages; [
    setuptools
  ];

  nativeBuildInputs = [
    zig
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
        substituteInPlace libpince/typedefs.py \
          --replace-fail 'GDB = "/bin/gdb"' 'GDB = "${lib.getExe gdb'}"'

        # The virtualenv GDB init file is absent from the Nix package.
        substituteInPlace libpince/debugcore.py \
          --replace-fail '    if not os.environ.get("APPDIR"):
            send_command("source ./gdbinit_venv")
    ' ""

        if [ "$(grep -c '"/var/log/pince.log"' libpince/utils.py)" = "2" ]; then
          substituteInPlace libpince/utils.py \
            --replace-fail 'logger = logging.getLogger("PINCE")' \
              'logger = logging.getLogger("PINCE")


    def get_log_path() -> str:
        log_dir = os.path.expanduser("~/.cache/pince")
        os.makedirs(log_dir, exist_ok=True)
        return os.path.join(log_dir, "pince.log")' \
            --replace-fail '"/var/log/pince.log"' 'get_log_path()';
        else
          echo "libpince/utils.py: expected 2 occurrences of /var/log/pince.log";
          exit 1;
        fi;

        substituteInPlace GUI/Settings/settings.py \
          --replace-fail 'guiutils.own_path_as_user("/var/log/pince.log")' \
            'guiutils.own_path_as_user(utils.get_log_path())'
  '';

  buildPhase = ''
    runHook preBuild

    export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-cache"

    # libmemscan (built ReleaseFast to match upstream)
    pushd libmemscan

    zig build -Doptimize=ReleaseFast

    mkdir -p ../libpince/libmemscan
    install -Dm555 zig-out/lib/libmemscan.so -t ../libpince/libmemscan/
    install -Dm444 memscan.py              -t ../libpince/libmemscan/
    popd

    # mono_collector (native + WINE agents, matching upstream install.sh)
    pushd mono_collector
    mkdir -p ../libpince/libmono_collector

    zig build -Doptimize=ReleaseFast -Dtarget=x86_64-linux-gnu
    install -Dm444 zig-out/lib/libmono_collector.so ../libpince/libmono_collector/mono_collector_x64.so

    zig build -Doptimize=ReleaseFast -Dtarget=x86-linux-gnu
    install -Dm444 zig-out/lib/libmono_collector.so ../libpince/libmono_collector/mono_collector_x86.so

    zig build -Doptimize=ReleaseFast -Dtarget=x86_64-windows-gnu
    install -Dm444 zig-out/bin/mono_collector.dll ../libpince/libmono_collector/mono_collector_wine_x64.dll

    zig build -Doptimize=ReleaseFast -Dtarget=x86-windows-gnu
    install -Dm444 zig-out/bin/mono_collector.dll ../libpince/libmono_collector/mono_collector_wine_x86.dll
    popd

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
    ''--prefix PATH : "${lib.makeBinPath [ pythonEnv ]}"''
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/pince/
    cp -r GUI i18n libpince media tr AUTHORS COPYING COPYING.CC-BY PINCE.py THANKS $out/lib/pince/

    install -Dm644 media/logo/ozgurozbek/pince_big_transparent.png \
      $out/share/icons/hicolor/512x512/apps/PINCE.png
    install -Dm644 media/logo/ozgurozbek/pince_small_transparent.png \
      $out/share/icons/hicolor/256x256/apps/PINCE.png


    install -Dm644 ${
      makeDesktopItem {
        name = "pince";
        desktopName = "PINCE";
        exec = "pince";
        icon = "PINCE";
        terminal = false;
        categories = [ "Debugger" ];
      }
    }/share/applications/pince.desktop \
      $out/share/applications/pince.desktop
    cp $out/share/applications/pince.desktop \
      $out/share/applications/io.github.korcankaraokcu.PINCE.desktop

    mkdir -p $out/bin
    ln -s $out/lib/pince/PINCE.py $out/bin/.pince-wrapped

    # Privilege-escalation launcher, mirroring upstream PINCE.sh.
    # PINCE.py itself now sets PYTHONDONTWRITEBYTECODE when running as root,
    # so we no longer inject it here.
    cat > $out/bin/pince << 'EOF'
    #!/usr/bin/env bash
    INNER="$(dirname -- "$(realpath -- "$0")")/.pince-wrapped";

    if [ -n "$1" ]; then
      PCT_DIR=$(cd -P -- "$(dirname -- "$1")" && pwd -P) || exit 1;
      PCT_FILE="$PCT_DIR/$(basename -- "$1")";
    fi

    if [ "$(id -u)" = "0" ]; then
      exec "$INNER" "$PCT_FILE";
    fi

    if command -v pkexec > /dev/null 2>&1; then
      # Preserve env vars to keep settings like theme preferences.
      # pkexec cannot pass all of env via a flag like "-E", so we
      # rebuild the env and pass it through explicitly.
      set --;
      while IFS= read -r line; do
        set -- "$@" "$line";
      done <<EOFENV
    $(printenv)
    EOFENV

      pince_stdout=/dev/null;
      pince_stderr=/dev/null;
      [ -t 1 ] && pince_stdout="/proc/$$/fd/1";
      [ -t 2 ] && pince_stderr="/proc/$$/fd/2";

      pkexec_err=$(LC_ALL=C pkexec --disable-internal-agent ${coreutils}/bin/env "$@" \
        sh -c 'out=$1; err=$2; shift 2; exec "$@" >"$out" 2>"$err"' \
        sh "$pince_stdout" "$pince_stderr" "$INNER" "$PCT_FILE" \
        2>&1 >/dev/null);
      pkexec_status=$?;

      case "$pkexec_err" in
        *"No authentication agent found"*) ;;
        *"Request dismissed"*) exit 126 ;;
        *)
          if [ -n "$pkexec_err" ]; then
            printf '%s\n' "$pkexec_err" >&2;
          fi
          exit "$pkexec_status";
          ;;
      esac
    fi

    if command -v sudo > /dev/null 2>&1; then
      # Debian/Ubuntu drops PATH through sudo even with -E, so force it.
      sudo -E --preserve-env=PATH "$INNER" "$PCT_FILE";
    else
      echo "No supported privilege escalation utility found.";
      exit 1;
    fi
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
    maintainers = with lib.maintainers; [
      mtrsk
      yuannan
    ];
  };
})
