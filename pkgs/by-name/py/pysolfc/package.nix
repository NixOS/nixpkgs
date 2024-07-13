{
  lib,
  callPackage,
  desktop-file-utils,
  fetchzip,
  freecell-solver,
  python3Packages,
  testers,
  # Configurable options
  withFreecellSolver ? true,
  withPillow ? true,
  withPygame ? true,
}:

let
  sources = callPackage ./sources.nix { };
  self = python3Packages.buildPythonApplication {
    inherit (sources.pysolfc) pname version src;
    pyproject = true;

    patches = [
      ./0000-pysolfc-datadir.patch
    ];

    dependencies = with python3Packages; ([
      attrs
      configobj
      pycotap
      pysol-cards
      random2
      six
      tkinter
    ] ++ lib.optionals withPillow [
      pillow
    ] ++ lib.optionals withPygame [
      pygame
    ]);

    build-system = [ python3Packages.setuptools ];

    nativeBuildInputs = [ desktop-file-utils ];

    propagatedBuildInputs = lib.optionals withFreecellSolver [
      freecell-solver
    ];

    # No tests in archive
    doCheck = false;

    postPatch = ''
      desktop-file-edit \
        --set-key Icon \
        --set-value ${placeholder "out"}/share/icons/pysol01.png data/pysol.desktop
    '';

    postInstall = ''
      mkdir -p $out/share/PySolFC/cardsets
      cp -r ${sources.cardsets.src}/* $out/share/PySolFC/cardsets
      cp -r ${sources.music.src}/data/music $out/share/PySolFC
    '';

    passthru = {
      tests.version = testers.testVersion {
        package = self;
        command = "pysol.py --version";
      };
    };

    meta = {
      homepage = "https://pysolfc.sourceforge.io";
      description = "Solitaire game collection writen in Python";
      longDescription = ''
        PySol Fan Club Edition (PySolFC) is a collection of more than 1200
        solitaire card games. It is a fork of PySol Solitaire.

        There are games that use the 52 card International Pattern deck, games
        for the 78 card Tarock deck, eight and ten suit Ganjifa games, Hanafuda
        games, Matrix games, Mahjongg games, and games for an original
        hexadecimal-based deck.

        Its features include a modern look and feel (uses the TTk widget set),
        multiple card sets and tableau backgrounds, sound, unlimited undo,
        player statistics, a hint system, demo games, a solitaire wizard,
        support for user written plug-ins, an integrated HTML help browser, and
        lots of documentation.
      '';
      license = lib.licenses.gpl3Plus;
      mainProgram = "pysol.py";
      maintainers = with lib.maintainers; [ kierdavis AndersonTorres ];
    };
  };
in
self
