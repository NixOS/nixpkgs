{
  lib,
  fetchFromGitHub,
  fontconfig,
  libxcb-cursor,
  python312,
  qt6,
  runCommand,
}:

python312.pkgs.buildPythonApplication (finalAttrs: {
  pname = "angr-management";
  # Keep angr-management, angr, archinfo, claripy, cle, and pyvex in sync.
  # nixpkgs-update: no auto update
  version = "9.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr-management";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k9N+Ok6me7gNHZ+kICnvwG366E/+v2lAGmHkUo38h5o=";
  };

  pythonRelaxDeps = [
    "binsync"
    "qtawesome"
  ];
  pythonRemoveDeps = [ "PySide6-Essentials" ];

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  buildInputs = [
    libxcb-cursor
    qt6.qtbase
    qt6.qtwayland
  ];

  build-system = with python312.pkgs; [ setuptools ];

  dependencies =
    with python312.pkgs;
    [
      angr
      bidict
      binsync
      cle
      ipython
      pyside6
      pyside6-qtads
      pyqodeng
      (qtawesome.override { pyqt6 = pyside6; })
      (qtconsole.override { pyqt6 = pyside6; })
      qtpy
      requests
      rpyc
      thefuzz
      tomlkit
    ]
    ++ angr.optional-dependencies.angrdb
    ++ requests.optional-dependencies.socks
    ++ thefuzz.optional-dependencies.speedup;

  pythonImportsCheck = [ "angrmanagement" ];

  dontWrapQtApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    makeWrapperArgs+=(--set-default QT_API pyside6)
    makeWrapperArgs+=(--set-default FONTCONFIG_FILE "${fontconfig.out}/etc/fonts/fonts.conf")
  '';

  passthru.tests.smoke =
    runCommand "angr-management-smoke-test"
      {
        __structuredAttrs = true;
        nativeBuildInputs = [
          (python312.withPackages (_: finalAttrs.finalPackage.dependencies))
        ];
      }
      ''
        export CI=1
        export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
        export HOME="$TMPDIR"
        export PYTHONPATH=${finalAttrs.finalPackage}/${python312.sitePackages}
        export QT_API=pyside6
        export QT_QPA_PLATFORM=offscreen
        python ${./tests/smoke.py} ${finalAttrs.version}

        set +e
        timeout 5s ${finalAttrs.finalPackage}/bin/angr-management >launcher.log 2>&1
        launcher_status=$?
        set -e
        if [ "$launcher_status" -ne 124 ]; then
          cat launcher.log
          exit 1
        fi

        touch "$out"
      '';

  meta = {
    description = "Graphical binary analysis tool powered by the angr binary analysis platform";
    homepage = "https://github.com/angr/angr-management";
    changelog = "https://github.com/angr/angr-management/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      connornelson
      scoder12
    ];
    mainProgram = "angr-management";
    platforms = lib.platforms.linux;
  };
})
