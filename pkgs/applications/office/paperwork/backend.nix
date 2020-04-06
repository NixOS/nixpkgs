{ buildPythonPackage, lib, fetchFromGitLab

, isPy3k, isPyPy

, pyenchant, simplebayes, pillow, pycountry, whoosh, termcolor
, python-Levenshtein, pygobject3, pyocr, natsort, libinsane
, distro

, pkgs
}:

buildPythonPackage rec {
  pname = "paperwork-backend";
  version = "1.3.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "paperwork";
    group = "World";
    owner = "OpenPaperwork";
    rev = version;
    sha256 = "1219yz8z4r1yn6miq8zc2z1m1lnhf3dmkhwfw23n05bg842nvg65";
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
    python-Levenshtein libinsane pygobject3 pyocr natsort
    pkgs.poppler_gi pkgs.gtk3 distro
  ];

  meta = {
    description = "Backend part of Paperwork (Python API, no UI)";
    homepage = https://openpaper.work/;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aszlig symphorien ];
  };
}
