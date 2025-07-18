{
  fetchFromGitHub,
  python3Packages,
  lib,
  qt6,
  nix-update-script,
  makeDesktopItem,
  copyDesktopItems,
  stdenv,
  desktopToDarwinBundle,
  writableTmpDirAsHomeHook,
}:
let
  version = "0.6.0";
in
python3Packages.buildPythonApplication {
  pname = "openmotor";
  inherit version;
  src = fetchFromGitHub {
    owner = "reilleya";
    repo = "openmotor";
    tag = "v${version}";
    hash = "sha256-6Os8+bhv4hTbsMAfXhlrv/sj9YjzC6Ny7r0a4Yfg5Qs";
  };

  buildInputs = [
    qt6.qtbase
  ];

  nativeBuildInputs =
    [
      python3Packages.pyqt6
      qt6.wrapQtAppsHook
      copyDesktopItems
      writableTmpDirAsHomeHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      desktopToDarwinBundle
    ];

  dependencies = with python3Packages; [
    cycler
    decorator
    docopt
    ezdxf
    imageio
    matplotlib
    networkx
    numpy
    pillow
    platformdirs
    pyparsing
    pyqt-distutils
    pyqt6
    pyyaml
    scikit-fmm
    scikit-image
    scipy
    six
    sphinx
  ];

  preBuild = ''
    # Call pyqt-distutils to "compile" the qt ui files to python
    python setup.py build_ui

    # For the buildPythonLibrary machinery to include the generated views we need to
    # make views a proper python module.
    touch uilib/views/__init__.py
  '';

  # The program's entrypoint is main.py (which calls app.py), neither of which are in
  # in a proper python module - so we do some chicanery and copy them to opt, add a
  # shebang so that main.py is executable, and link it to bin
  postInstall = ''
    mkdir -p $out/{opt,bin}
    cp main.py app.py $out/opt/
    sed -i '1 i\#!/usr/bin/env python3' $out/opt/main.py
    chmod +x $out/opt/main.py
    ln -s $out/opt/main.py $out/bin/openmotor

    install -Dm644 resources/oMIconCycles.png $out/share/icons/hicolor/256x256/apps/openmotor.png
  '';
  # wrapPythonPrograms won't have wrapped the symlinks in bin, we have to call it
  # on the main.py in opt manually
  postFixup = ''
    wrapPythonProgramsIn "$out/opt/" "$out $pythonPath"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "openmotor";
      desktopName = "openMotor";
      icon = "openmotor";
      exec = "openmotor";
      mimeTypes = [ "application/vnd.openmotor+yaml" ];
      categories = [
        "Science"
        "Physics"
        "Engineering"
        "Qt"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/reilleya/openMotor";
    description = "Internal ballistics simulator for rocket motor experimenters";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.samw ];
    platforms = lib.platforms.unix;
    mainProgram = "openmotor";
  };
}
