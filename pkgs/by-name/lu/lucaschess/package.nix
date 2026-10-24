{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  copyDesktopItems,
  lc0,
  makeDesktopItem,
  makeShellWrapper,
  p7zip,
  python3,
  qt6,
  stockfish,
}:

let
  version = "6.2.0";

  # FasterCode uses x86 cpuid
  platforms = [ "x86_64-linux" ];

  src = fetchFromGitHub {
    owner = "lukasmonk";
    repo = "lucaschessR6";
    tag = "R${version}";
    # Remove prebuilt binaries, some of them unfree
    postFetch = ''
      cd $out/bin/OS
      rm -r win32 linux/DigitalBoards linux/FasterCode.*
      find linux/Engines -mindepth 1 -maxdepth 1 \
        ! -name irina ! -name eguzki ! -name eguzkilore ! -name maia -exec rm -r {} +
      rm linux/Engines/{irina/irina,eguzki/eguzki,eguzkilore/eguzkilore,maia/Lc0-0.27.0,maia/src.7z}
    '';
    hash = "sha256-N30CC7BmYOL2ieioYyhvVtMca/394cehdA4ee846xjQ=";
  };

  fastercode = python3.pkgs.toPythonModule (
    stdenv.mkDerivation {
      pname = "lucaschess-fastercode";
      inherit version src;
      sourceRoot = "${src.name}/bin/_fastercode";

      nativeBuildInputs = [
        (python3.withPackages (ps: [
          ps.cython
          # for distutils
          ps.setuptools
        ]))
      ];

      # irina/defs.h typedefs bool, a keyword in C23
      env.NIX_CFLAGS_COMPILE = "-std=gnu17";

      buildPhase = ''
        runHook preBuild
        # upstream's script doesn't stop on errors
        bash -e fastercode_linux.sh
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        install -Dm555 -t $out/${python3.sitePackages} src/FasterCode*.so
        runHook postInstall
      '';

      meta = {
        description = "Move generation, PGN and Polyglot core of Lucas Chess";
        license = lib.licenses.gpl3Only;
        inherit platforms;
      };
    }
  );

  # Upstream Makefiles link statically
  buildEngine =
    {
      name,
      compile,
      license,
      postPatch ? "",
    }:
    stdenv.mkDerivation {
      pname = "lucaschess-${name}";
      inherit version postPatch;
      src = "${src}/bin/OS/linux/Engines/${name}/src.7z";

      nativeBuildInputs = [ p7zip ];
      unpackCmd = "7z x $curSrc";
      sourceRoot = "src";

      buildPhase = ''
        runHook preBuild
        ${compile}
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        install -Dm755 ${name} -t $out/bin
        runHook postInstall
      '';

      meta = {
        description = "UCI chess engine written by the author of Lucas Chess";
        inherit license platforms;
        mainProgram = name;
      };
    };

  engines = {
    irina = buildEngine {
      name = "irina";
      compile = "$CC -std=gnu17 -O3 -DNDEBUG -o irina *.c";
      license = lib.licenses.gpl3Plus;
    };
    # Source headers say GPL-3.0-or-later, LICENSE.txt is the GPL-2 text
    eguzki = buildEngine {
      name = "eguzki";
      compile = "$CXX -O3 -DNDEBUG -o eguzki *.cpp";
      license = lib.licenses.gpl3Plus;
      postPatch = eguzkiFormatFix;
    };
    eguzkilore = buildEngine {
      name = "eguzkilore";
      compile = "$CXX -O3 -DNDEBUG -o eguzkilore *.cpp";
      license = lib.licenses.gpl3Plus;
      postPatch = eguzkiFormatFix;
    };
  };

  # Fix build with -Werror=format-security
  eguzkiFormatFix = ''
    substituteInPlace test.cpp --replace-fail 'printf(test[i]);' 'printf("%s", test[i]);'
    substituteInPlace eval.cpp --replace-fail 'printf(factor_name[fc]);' 'printf("%s", factor_name[fc]);'
  '';

  dependencies = with python3.pkgs; [
    charset-normalizer
    chess
    fastercode
    pillow
    polib
    psutil
    pyside6
    requests
    sortedcontainers
  ];

  # Helper processes are started with sys.executable
  pythonEnv = python3.withPackages (_: dependencies);
in
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "lucaschess";
  inherit version src;
  pyproject = false;

  patches = [
    # Write user data to $LUCASCHESS_HOME instead of the install directory
    ./configurable-data-dir.patch
    ./absolute-file-arguments.patch
    ./remove-unpackaged-engines.patch
  ];

  postPatch = ''
    substituteInPlace bin/OS/linux/OSEngines.py \
      --replace-fail "@stockfishVersion@" "${stockfish.version}"

    # Helper processes run optimized like the launcher, without PYTHONOPTIMIZE leaking into engines
    substituteInPlace bin/Code/Z/XRun.py \
      --replace-fail "li.append(sys.executable)" 'li.extend((sys.executable, "-O"))'

    # Files copied out of the store are read-only
    substituteInPlace bin/Code/GM/GM.py \
      --replace-fail "shutil.copytree(folder_ori_gm, folder_gm)" \
                     "shutil.copytree(folder_ori_gm, folder_gm, copy_function=shutil.copyfile)
            folder_gm.chmod(0o755)" \
      --replace-fail "shutil.copy(entry, folder_gm)" "shutil.copyfile(entry, folder_gm / entry.name)"
    substituteInPlace bin/Code/Z/Util.py \
      --replace-fail "shutil.copy2(origin_path, destino_path)" \
                     "shutil.copy2(origin_path, destino_path)
            if destino_path.is_file():
                destino_path.chmod(destino_path.stat().st_mode | 0o200)"
    substituteInPlace bin/Code/QT/Piezas.py \
      --replace-fail "shutil.copy(source_file, dest_file)" "shutil.copyfile(source_file, dest_file)" \
      --replace-fail "shutil.copy(ori, dest)" "shutil.copyfile(ori, dest)"

    substituteInPlace bin/Code/Z/Update.py \
      --replace-fail "def update(main_window):" \
                     "def update(main_window):
        QTMessages.message(main_window, 'This Lucas Chess is installed with Nix. Update it through Nix.')
        return False" \
      --replace-fail "def update_manual(main_window) -> bool:" \
                     "def update_manual(main_window) -> bool:
        return update(main_window)" \
      --replace-fail "def test_update(procesador):" \
                     "def test_update(procesador):
        return"
  '';

  nativeBuildInputs = [
    copyDesktopItems
    makeShellWrapper
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtsvg
  ];

  inherit dependencies;

  dontBuild = true;
  dontWrapPythonPrograms = true;
  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    share=$out/share/lucaschess
    mkdir -p $share/bin/OS/linux/Engines
    cp -r bin/LucasR.py bin/Code $share/bin/
    cp bin/OS/linux/OSEngines.py $share/bin/OS/linux/
    cp -r Resources $share/

    # Engines run from their own folder, next to their data
    src_engines=bin/OS/linux/Engines
    dst_engines=$share/bin/OS/linux/Engines
    mkdir -p $dst_engines/{stockfish,maia,irina,eguzki,eguzkilore}
    ln -s ${lib.getExe stockfish} $dst_engines/stockfish/stockfish
    ln -s ${lib.getExe' lc0 "lc0"} $dst_engines/maia/lc0
    cp $src_engines/maia/{maia-*.pb.gz,*.bin,COPYING} $dst_engines/maia/
    ln -s ${engines.irina}/bin/irina $dst_engines/irina/irina
    ln -s ${engines.eguzki}/bin/eguzki $dst_engines/eguzki/eguzki
    ln -s ${engines.eguzkilore}/bin/eguzkilore $dst_engines/eguzkilore/eguzkilore
    for name in irina eguzki eguzkilore; do
      find $src_engines/$name -maxdepth 1 -type f ! -name $name \
        ! -name '*.7z' ! -name '*.zip' ! -name '*.tar.gz' -exec cp -t $dst_engines/$name {} +
    done

    # WAL databases can't be read from the read-only store
    ${python3.interpreter} - $share/Resources <<'EOF'
    import pathlib, sqlite3, sys
    for p in pathlib.Path(sys.argv[1]).rglob("*"):
        if not p.is_file():
            continue
        with p.open("rb") as f:
            header = f.read(19)
        if header[:16] == b"SQLite format 3\0" and header[18] == 2:
            con = sqlite3.connect(p)
            con.execute("PRAGMA journal_mode=DELETE")
            con.close()
    EOF

    # Not parallel, -j makes the output non-reproducible
    ${python3.interpreter} -m compileall -q -o 1 --invalidation-mode unchecked-hash \
      $share/bin/Code $share/bin/OS/linux/OSEngines.py

    # Code/__init__ expands ~, also when HOME is unset
    makeShellWrapper ${pythonEnv.interpreter} $out/bin/lucaschess \
      --add-flags "-O $share/bin/LucasR.py" \
      --run 'export LUCASCHESS_HOME="''${LUCASCHESS_HOME:-''${XDG_DATA_HOME:-~/.local/share}/lucaschess}"' \
      "''${qtWrapperArgs[@]}"

    install -Dm644 Resources/IntFiles/logo64r.png $out/share/icons/hicolor/64x64/apps/lucaschess.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "lucaschess";
      desktopName = "Lucas Chess";
      genericName = "Chess GUI";
      comment = "Train, play against engines and run engine tournaments";
      exec = "lucaschess %f";
      icon = "lucaschess";
      categories = [
        "Game"
        "BoardGame"
      ];
      mimeTypes = [ "application/x-chess-pgn" ];
    })
  ];

  passthru = {
    inherit fastercode engines pythonEnv;
    tests.smoke = callPackage ./tests.nix { lucaschess = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Chess GUI for training, play against UCI engines and engine tournaments";
    homepage = "https://lucaschess.pythonanywhere.com";
    license = with lib.licenses; [
      gpl3Only # Lucas Chess, Maia weights
      gpl3Plus # engines
      # piece sets
      gpl2Only
      lgpl2Only
    ];
    maintainers = with lib.maintainers; [ tristanlirette ];
    mainProgram = "lucaschess";
    inherit platforms;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
