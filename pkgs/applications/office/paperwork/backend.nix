{ buildPythonPackage, lib, fetchFromGitHub

, isPy3k, isPyPy

, pyenchant, simplebayes, pillow, pycountry, whoosh, termcolor
, python-Levenshtein, pyinsane2, pygobject3, pyocr, natsort

, pkgs
}:

buildPythonPackage rec {
  pname = "paperwork-backend";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "openpaperwork";
    repo = "paperwork-backend";
    rev = version;
    sha256 = "1rvf06vphm32601ja1bfkfkfpgjxiv0lh4yxjy31jll0bfnsf7pf";
  };

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
