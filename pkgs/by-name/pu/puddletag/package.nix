{
  lib,
  fetchFromGitHub,
  python3,
  libsForQt5,
}:

let
  qt = libsForQt5;

in
python3.pkgs.buildPythonApplication rec {
  pname = "puddletag";
  version = "2.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "puddletag";
    repo = "puddletag";
    tag = version;
    hash = "sha256-Per+olIi2yd2cNRO22Fi6cC7/90AqRP1NpRK1XU1i0A=";
  };

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    "chromaprint"
    "pyqt5-qt5"
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail share/pixmaps share/icons
  '';

  buildInputs = with qt; [
    qtbase
    qtwayland
  ];

  nativeBuildInputs = with qt; [
    wrapQtAppsHook
  ];

  dependencies = with python3.pkgs; [
    configobj
    levenshtein
    lxml
    mutagen
    pyacoustid
    pyparsing
    pyqt5
    rapidfuzz
    unidecode
  ];

  # the file should be executable but it isn't so our wrapper doesn't run
  preFixup = ''
    chmod 555 $out/bin/puddletag
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  doCheck = false; # there are no tests

  dontWrapQtApps = true; # to avoid double-wrapping

  dontStrip = true; # we are not generating any binaries

  meta = {
    description = "Audio tag editor similar to the Windows program, Mp3tag";
    mainProgram = "puddletag";
    homepage = "https://docs.puddletag.net";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      peterhoeg
      dschrempf
    ];
    platforms = lib.platforms.linux;
  };
}
