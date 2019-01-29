{ buildPythonPackage, lib, fetchFromGitLab

, isPy3k, isPyPy

, pyenchant, simplebayes, pillow, pycountry, whoosh, termcolor
, python-Levenshtein, pyinsane2, pygobject3, pyocr, natsort

, pkgs
}:

buildPythonPackage rec {
  pname = "paperwork-backend";
  version = "1.2.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "paperwork";
    group = "World";
    owner = "OpenPaperwork";
    rev = version;
    sha256 = "0wjjiw99aswmppnhzq3jir0p5p78r3m8hjinhdirkgm6h7skq5p4";
  };

  sourceRoot = "source/paperwork-backend";

  # Python 2.x is not supported.
  disabled = !isPy3k && !isPyPy;

  patchPhase = ''
    echo 'version = "${version}"' > paperwork_backend/_version.py
  '';

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
