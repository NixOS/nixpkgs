{ lib
, fetchFromGitHub
, python3
, wrapQtAppsHook
}:

# As of 2.1, puddletag has started pinning versions of all dependencies that it
# was built against which is an issue as the chances of us having the exact same
# versions in nixpkgs are slim to none.
#
# There is a difference between explicit and implicit version requirements and
# we should be able to safely ignore the latter. Therefore use requirements.in
# which contains just the explicit version dependencies instead of
# requirements.txt.
#
# Additionally, we do need to override some of the explicit requirements through
# `overrideVersions`. While we technically run the risk of breaking something by
# ignoring the pinned versions, it's just something we will have to accept
# unless we want to vendor those versions.


python3.pkgs.buildPythonApplication rec {
  pname = "puddletag";
  version = "2.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "puddletag";
    repo = "puddletag";
    rev = "refs/tags/${version}";
    hash = "sha256-KaFfpOWI9u2ZC/3kuCLneWOOKSmAaIuHPFHptkKMH/g=";
  };

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    "chromaprint"
    "pyqt5-qt5"
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace share/pixmaps share/icons
  '';

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
  ];

  # the file should be executable but it isn't so our wrapper doesn't run
  preFixup = ''
    chmod 555 $out/bin/puddletag
    wrapQtApp $out/bin/puddletag
  '';

  doCheck = false; # there are no tests

  dontStrip = true; # we are not generating any binaries

  meta = with lib; {
    description = "An audio tag editor similar to the Windows program, Mp3tag";
    homepage = "https://docs.puddletag.net";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ peterhoeg dschrempf ];
    platforms = platforms.linux;
  };
}
