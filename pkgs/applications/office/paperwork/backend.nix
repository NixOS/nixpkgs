{ buildPythonPackage, lib

, isPy3k, isPyPy

, pyenchant, simplebayes, pillow, pycountry, whoosh, termcolor
, python-Levenshtein, pyinsane2, pygobject3, pyocr, natsort

, pkgs, callPackage
}:
let
  source = (callPackage ./source.nix {});
in buildPythonPackage rec {
  pname = "paperwork-backend";
  inherit (source) version;

  src = source.backend;

  # Python 2.x is not supported.
  disabled = !isPy3k && !isPyPy;

  preCheck = "\"$out/bin/paperwork-shell\" chkdeps paperwork_backend";

  propagatedBuildInputs = [
    pyenchant simplebayes pillow pycountry whoosh termcolor
    python-Levenshtein pyinsane2 pygobject3 pyocr natsort
    pkgs.poppler_gi pkgs.gtk3
  ];

  meta = {
    description = "Backend part of Paperwork (Python API, no UI)";
    homepage = https://openpaper.work/;
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.aszlig ];
  };
}
