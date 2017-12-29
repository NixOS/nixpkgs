{ buildPythonPackage, lib, fetchFromGitHub

, isPy3k, isPyPy

, pyenchant, simplebayes, pillow, pycountry, whoosh, termcolor
, python-Levenshtein, pyinsane2, pygobject3, pyocr, natsort

, pkgs
}:

buildPythonPackage rec {
  name = "paperwork-backend-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "openpaperwork";
    repo = "paperwork-backend";
    rev = version;
    sha256 = "1lrawibm6jnykj1bkrl8196kcxrhndzp7r0brdrb4hs54gql7j5x";
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
