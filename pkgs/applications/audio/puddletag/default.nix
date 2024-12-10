{
  lib,
  fetchFromGitHub,
  fetchurl,
  python3,
  qtbase,
  qtwayland,
  wrapQtAppsHook,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "puddletag";
  version = "2.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "puddletag";
    repo = "puddletag";
    rev = "refs/tags/${version}";
    hash = "sha256-oScT8YcQoDf2qZ+J7xKm22Sbfym3tkVUrWT5D2LU5e8=";
  };

  patches = [
    (fetchurl {
      url = "https://github.com/puddletag/puddletag/commit/54074824adb05da42c03d7adfbba94d8e24982f0.patch";
      hash = "sha256-DkgaFWgp2m2bRuhdXhHW+nxV/2GaCgeRNdwLMYAkcYQ=";
      name = "fix_for_pyparsing_3_1_2.patch";
    })
  ];

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    "chromaprint"
    "pyqt5-qt5"
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace share/pixmaps share/icons
  '';

  buildInputs = [
    qtbase
    qtwayland
  ];

  nativeBuildInputs = [
    python3.pkgs.pythonRelaxDepsHook
    wrapQtAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
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

  meta = with lib; {
    description = "An audio tag editor similar to the Windows program, Mp3tag";
    mainProgram = "puddletag";
    homepage = "https://docs.puddletag.net";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      peterhoeg
      dschrempf
    ];
    platforms = platforms.linux;
  };
}
