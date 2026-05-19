{
  lib,
  stdenv,
  fetchFromGitHub,
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
  src = fetchFromGitHub {
    owner = "shlomif";
    repo = "PySolFC";
    tag = "pysolfc-${finalAttrs.version}";
    hash = "sha256-Ky5lyr2dxP/gai/DPZXAtoJSYp0I2TM/rWUNFG1yNyU=";
  };

  format = "setuptools";


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

  passthru = {
    cardsets = stdenv.mkDerivation (cardsetsAttrs: {
      pname = "pysol-cardsets";
      version = "3.1";

      src = fetchFromGitHub {
        owner = "shlomif";
        repo = "PySolFC-CardSets";
        tag = cardsetsAttrs.version;
        hash = "sha256-agbfeM19BCdbk73KZpvoRR0fCOSR7cpqlt7T1/MlM9g=";
      };

      installPhase = ''
        runHook preInstall
        mkdir -p "$out"
        cp -r . "$out"
        runHook postInstall
      '';
    });

    music = stdenv.mkDerivation (musicAttrs: {
      pname = "pysol-music";
      version = "4.50";

      src = fetchFromGitHub {
        owner = "shlomif";
        repo = "pysol-music";
        tag = musicAttrs.version;
        hash = "sha256-sOl5U98aIorrQHJRy34s0HHaSW8hMUE7q84FMQAj5Yg=";
      };

      installPhase = ''
        runHook preInstall
        mkdir -p "$out"
        cp -r . "$out"
        runHook postInstall
      '';
    });

    updateScript = _experimental-update-script-combinators.sequence (
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
  };

  meta = {
    description = "Collection of more than 1000 solitaire card games";
    mainProgram = "pysol.py";
    homepage = "https://pysolfc.sourceforge.io";
    license = lib.licenses.gpl3;
    maintainers = [ ];
  };
}
