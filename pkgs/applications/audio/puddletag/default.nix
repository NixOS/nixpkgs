{ lib, fetchFromGitHub, python3Packages, wrapQtAppsHook, chromaprint }:

python3Packages.buildPythonApplication rec {
  pname = "puddletag";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "puddletag";
    repo = "puddletag";
    rev = version;
    hash = "sha256-eilETaFvvPMopIbccV1uLbpD55kHX9KGTCcGVXaHPgM=";
  };

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = [ chromaprint ] ++ (with python3Packages; [
    python3Packages.chromaprint
    configobj
    levenshtein
    lxml
    mutagen
    pyacoustid
    pyparsing
    pyqt5
  ]);

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "levenshtein==0.16.0" "levenshtein" \
      --replace "pyparsing==3.0.7" "pyparsing" \
      --replace "pyqt5==5.15.6" "pyqt5" \
      --replace "pyqt5-sip==12.9.0" "pyqt5-sip" \
      --replace "rapidfuzz==1.8.3" "rapidfuzz"
    # According to PyPi, 'pyqt5-qt5' is a subset of 'pyqt5'.
    sed -i '/pyqt5-qt5/d' requirements.txt
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  doCheck = false; # there are no tests

  dontStrip = true; # we are not generating any binaries

  meta = with lib; {
    description = "An audio tag editor similar to the Windows program, Mp3tag";
    homepage = "https://docs.puddletag.net";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
