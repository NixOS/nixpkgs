{ lib, fetchFromGitHub, python3Packages, wrapQtAppsHook }:

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

let
  # NOTE: check if we can drop any of these overrides when bumping the version
  overrideVersions = [
    "pyparsing"
    "pyqt5"
  ];

in
python3Packages.buildPythonApplication rec {
  pname = "puddletag";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "puddletag";
    repo = "puddletag";
    rev = version;
    hash = "sha256-eilETaFvvPMopIbccV1uLbpD55kHX9KGTCcGVXaHPgM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace share/pixmaps share/icons

    cp requirements.in requirements.txt
  '' + lib.concatMapStringsSep "\n"
    (e: ''
      sed -i requirements.txt -e 's/^${e}.*/${e}/'
    '')
    overrideVersions;

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = with python3Packages; [
    pyacoustid
    chromaprint
    configobj
    levenshtein
    lxml
    mutagen
    pyparsing
    pyqt5
    rapidfuzz
  ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
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
