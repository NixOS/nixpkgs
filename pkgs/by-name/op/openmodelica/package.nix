{
  lib,
  stdenv,
  autoconf,
  fetchFromGitHub,
  blas,
  boost,
  bison,
  cmake,
  curl,
  expat,
  flex,
  gfortran,
  gettext,
  jdk_headless,
  lapack,
  libffi,
  libGL,
  libuuid,
  makeShellWrapper,
  ninja,
  openscenegraph,
  pkg-config,
  python3,
  qt6,
  readline,
  xdg-utils,
  zstd,
}:
stdenv.mkDerivation (
  finalAttrs:
  let
    wrapperPath = lib.makeBinPath [
      gfortran
      stdenv.cc
      xdg-utils
    ];
    wrapperLibraryPath = lib.makeLibraryPath [
      blas
      lapack
      stdenv.cc.cc
      stdenv.cc.cc.lib
    ];
    wrapperLdLibraryPath = lib.concatStringsSep ":" [
      "${placeholder "out"}/lib/omc"
      "${placeholder "out"}/lib/omc/cpp"
      "${placeholder "out"}/lib/omc/omsicpp"
      (lib.makeLibraryPath [ stdenv.cc.cc.lib ])
    ];
    modelicaStandardLibrary = lib.mapAttrs (
      _: source:
      fetchFromGitHub {
        owner = "OpenModelica";
        repo = "OpenModelica-ModelicaStandardLibrary";
        inherit (source) rev hash;
      }
    ) finalAttrs.passthru.modelicaStandardLibrarySources;
    modelicaStandardLibrarySourceMap = builtins.toJSON (
      lib.mapAttrs' (
        name: source: lib.nameValuePair source.rev "${modelicaStandardLibrary.${name}}"
      ) finalAttrs.passthru.modelicaStandardLibrarySources
    );
  in
  {
    pname = "openmodelica";
    version = "1.27.0";
    srcRev = "v${finalAttrs.version}";
    srcHash = "sha256-fq7+9iBAz7JrvXTMaj1pxPal5haLgka62uocLsBhwnE=";

    src = fetchFromGitHub {
      owner = "OpenModelica";
      repo = "OpenModelica";
      rev = finalAttrs.srcRev;
      hash = finalAttrs.srcHash;
      fetchSubmodules = true;
    };

    postPatch = ''
      echo "v${finalAttrs.version}" > OMVERSION.txt
      echo "v${finalAttrs.version}" > version.txt
      echo "v${finalAttrs.version}" > OMSimulator/version.txt
    '';

    nativeBuildInputs = [
      autoconf
      bison
      cmake
      flex
      gfortran
      jdk_headless
      makeShellWrapper
      ninja
      pkg-config
      python3
      qt6.qttools
      qt6.wrapQtAppsHook
    ];

    buildInputs = [
      blas
      boost
      curl
      expat
      gettext
      lapack
      libffi
      libGL
      libuuid
      openscenegraph
      qt6.qt5compat
      qt6.qtbase
      qt6.qthttpserver
      qt6.qtsvg
      qt6.qtwebengine
      readline
      stdenv.cc.cc
      stdenv.cc.cc.lib
      zstd
    ];

    cmakeFlags = [
      (lib.cmakeBool "OM_USE_CCACHE" false)
      (lib.cmakeFeature "OM_QT_MAJOR_VERSION" "6")
      (lib.cmakeBool "OM_ENABLE_GUI_CLIENTS" true)
      (lib.cmakeBool "OM_OMEDIT_ENABLE_TESTS" false)
      (lib.cmakeBool "OM_OMS_ENABLE_TESTSUITE" false)
      (lib.cmakeBool "OM_OMC_ENABLE_FORTRAN" true)
      (lib.cmakeBool "OM_OMC_ENABLE_MOO" true)
      (lib.cmakeBool "OM_OMC_ENABLE_OPTIMIZATION" true)
      (lib.cmakeBool "OM_OMC_ENABLE_PRIMME" true)
      (lib.cmakeBool "OM_OMC_ENABLE_COLPACK" true)
      (lib.cmakeBool "OM_OMC_ENABLE_CPP_RUNTIME" true)
      (lib.cmakeBool "OM_OMC_USE_LAPACK" true)
      (lib.cmakeBool "OM_OMC_USE_CORBA" false)
      (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    ];

    env = {
      NIX_CFLAGS_COMPILE = toString [
        "-Wno-error=implicit-function-declaration"
        "-Wno-error=incompatible-pointer-types"
      ];
      NIX_LDFLAGS = toString [
        "-L${stdenv.cc.cc.lib}/lib"
        "-rpath"
        "${stdenv.cc.cc.lib}/lib"
      ];
    };

    qtWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      wrapperPath
      "--prefix"
      "LIBRARY_PATH"
      ":"
      wrapperLibraryPath
      "--prefix"
      "LD_LIBRARY_PATH"
      ":"
      wrapperLdLibraryPath
    ];

    postInstall = ''
      if [ -d "$out/lib/omc/pkgconfig" ]; then
        find "$out/lib/omc/pkgconfig" -name '*.pc' -exec sed -i \
          -e 's|''${prefix}//nix/store/|/nix/store/|g' \
          -e 's|''${exec_prefix}//nix/store/|/nix/store/|g' \
          {} +
      fi

      export libraryIndex=../libraries/install-index.json
      export modelicaStandardLibrarySourceMap=${lib.escapeShellArg modelicaStandardLibrarySourceMap}
      install -Dm444 "$libraryIndex" "$out/lib/omlibrary/index.json"

      python3 <<'PY'
      import json
      import os
      import shutil
      from pathlib import Path

      sources = {
          revision: Path(path)
          for revision, path in json.loads(os.environ["modelicaStandardLibrarySourceMap"]).items()
      }
      out = Path(os.environ["out"])
      library_root = out / "lib" / "omlibrary"
      with open(os.environ["libraryIndex"], encoding="utf-8") as handle:
          index = json.load(handle)

      for name, package in index["libs"].items():
          for version, metadata in package["versions"].items():
              source_path = sources[metadata["sha"]] / metadata["path"]
              target = library_root / f"{name} {version}"
              target.mkdir(parents=True, exist_ok=True)

              if source_path.is_dir():
                  shutil.copytree(source_path, target, dirs_exist_ok=True, symlinks=True)
              else:
                  shutil.copy2(source_path, target / "package.mo")

              target.chmod(target.stat().st_mode | 0o200)
              metadata_path = target / "openmodelica.metadata.json"
              if metadata_path.exists():
                  metadata_path.chmod(metadata_path.stat().st_mode | 0o200)

              with open(metadata_path, "w", encoding="utf-8") as handle:
                  json.dump(metadata, handle, separators=(",", ":"))
                  handle.write("\n")
      PY
    '';

    postFixup = ''
      openModelicaLibraryPath='export OPENMODELICALIBRARY="${placeholder "out"}/lib/omlibrary:''${HOME}/.openmodelica/libraries''${OPENMODELICALIBRARY:+:}''${OPENMODELICALIBRARY}''${MODELICAPATH:+:}''${MODELICAPATH}"'

      wrapProgramShell $out/bin/omc \
        --run "$openModelicaLibraryPath" \
        --prefix PATH : "${wrapperPath}" \
        --prefix LIBRARY_PATH : "${wrapperLibraryPath}" \
        --prefix LD_LIBRARY_PATH : "${wrapperLdLibraryPath}"

      if [ -x "$out/bin/OMEdit" ]; then
        wrapProgramShell $out/bin/OMEdit \
          --run "$openModelicaLibraryPath"
      fi

      if [ -x "$out/bin/OMShell-terminal" ]; then
        wrapProgramShell $out/bin/OMShell-terminal \
          --run "$openModelicaLibraryPath" \
          --prefix LD_LIBRARY_PATH : "${wrapperLdLibraryPath}"
      fi
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck

      $out/bin/omc --version
      $out/bin/OMSimulator --version
      cat > load-modelica.mos <<'EOF'
      loadModel(Modelica);
      getErrorString();
      EOF
      $out/bin/omc load-modelica.mos | tee load-modelica.out
      grep -qx true load-modelica.out

      runHook postInstallCheck
    '';

    passthru = {
      updateScript = ./update.py;

      modelicaStandardLibrarySources = {
        v3_2_3 = {
          rev = "efd981a1176f124938d6d6759f7c09e0fbf55ddf";
          hash = "sha256-9xKkWUS/Q52UKzhFGTZe/0bfaG89PLqsMSwTmjeZ/lo=";
        };
        v4_0_0 = {
          rev = "96032134c36668898e1693e69bd9f81aa38de3dd";
          hash = "sha256-WDwGfkaVJ2eQw0Air9Jk6cuxiBc7kN9kuWy+CpGrIv8=";
        };
        v4_1_0 = {
          rev = "7a4bf7de77a3986e8eb1e88cbb515d646f78f834";
          hash = "sha256-2DZv76oRZztiIfVH4WSEsrVJRpzd8qqOEZTRTOj1Kx0=";
        };
      };
    };

    meta = {
      description = "Modelica-based modeling and simulation environment";
      longDescription = ''
        OpenModelica is an open-source Modelica-based modeling and simulation
        environment. This package builds the compiler, simulation runtimes,
        Modelica libraries, OMSimulator, OMEdit, OMPlot, OMShell, OMNotebook,
        and related Qt 6 GUI clients from the upstream release.
      '';
      homepage = "https://openmodelica.org/";
      changelog = "https://github.com/OpenModelica/OpenModelica/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [
        ppenguin
      ];
      mainProgram = "omc";
      platforms = lib.platforms.linux;
    };
  }
)
