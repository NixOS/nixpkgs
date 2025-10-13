{
  lib,
  stdenv,
  fetchzip,
  python3Packages,
  desktop-file-utils,
  freecell-solver,
  black-hole-solver,
  _experimental-update-script-combinators,
  gitUpdater,
}:

python3Packages.buildPythonApplication rec {
  pname = "pysolfc";
  version = "3.4.1";
  format = "setuptools";

  src = fetchzip {
    url = "mirror://sourceforge/pysolfc/PySolFC-${version}.tar.xz";
    hash = "sha256-jijrrWhj80n/XFKMFLptDZCsclIhdJHiTrX6CGjVju8=";
  };

  cardsets = stdenv.mkDerivation rec {
    pname = "pysol-cardsets";
    version = "3.1";

    src = fetchzip {
      url = "mirror://sourceforge/pysolfc/PySolFC-Cardsets-${version}.tar.bz2";
      hash = "sha256-NyCnMlMZ6d5+IiyG4cVn/zlDlArLJSs0dIqZiD7Nv4M=";
    };

    installPhase = ''
      runHook preInstall
      cp -r $src $out
      runHook postInstall
    '';
  };

  music = stdenv.mkDerivation rec {
    pname = "pysol-music";
    version = "4.50";

    src = fetchzip {
      url = "mirror://sourceforge/pysolfc/pysol-music-${version}.tar.xz";
      hash = "sha256-sOl5U98aIorrQHJRy34s0HHaSW8hMUE7q84FMQAj5Yg=";
    };

    installPhase = ''
      runHook preInstall
      cp -r $src $out
      runHook postInstall
    '';
  };

  propagatedBuildInputs = with python3Packages; [
    tkinter
    six
    random2
    configobj
    pysol-cards
    attrs
    pycotap
    # optional :
    pygame
    freecell-solver
    black-hole-solver
    pillow
  ];

  patches = [ ./pysolfc-datadir.patch ];

  nativeBuildInputs = [ desktop-file-utils ];

  postInstall = ''
    mkdir $out/share/PySolFC/cardsets
    cp -r $cardsets/* $out/share/PySolFC/cardsets
    cp -r $music/data/music $out/share/PySolFC
  '';

  # No tests in archive
  doCheck = false;

  passthru.updateScript = _experimental-update-script-combinators.sequence (
    # Needed in order to work around requirement that only one updater with features enabled is in sequence
    map (updater: updater.command) [
      (gitUpdater {
        url = "https://github.com/shlomif/PySolFC.git";
        rev-prefix = "pysolfc-";
      })
      (gitUpdater {
        url = "https://github.com/shlomif/PySolFC-CardSets.git";
        attrPath = "pysolfc.cardsets";
      })
      (gitUpdater {
        url = "https://github.com/shlomif/pysol-music.git";
        attrPath = "pysolfc.music";
      })
    ]
  );

  meta = with lib; {
    description = "Collection of more than 1000 solitaire card games";
    mainProgram = "pysol.py";
    homepage = "https://pysolfc.sourceforge.io";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };
}
