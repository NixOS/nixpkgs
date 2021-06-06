{ buildPythonPackage
, lib
, fetchFromGitLab

, isPy3k
, isPyPy

, pyenchant
, simplebayes
, pypillowfight
, pycountry
, whoosh
, termcolor
, python-Levenshtein
, pygobject3
, pyocr
, natsort
, libinsane
, distro
, openpaperwork-core
, openpaperwork-gtk
, psutil

, pkgs
}:

buildPythonPackage rec {
  pname = "paperwork-backend";
  inherit (import ./src.nix { inherit fetchFromGitLab; }) version src;

  sourceRoot = "source/paperwork-backend";

  # Python 2.x is not supported.
  disabled = !isPy3k && !isPyPy;

  patchPhase = ''
    echo 'version = "${version}"' > src/paperwork_backend/_version.py
    chmod a+w -R ..
    patchShebangs ../tools
  '';

  propagatedBuildInputs = [
    pyenchant
    simplebayes
    pypillowfight
    pycountry
    whoosh
    termcolor
    python-Levenshtein
    libinsane
    pygobject3
    pyocr
    natsort
    pkgs.poppler_gi
    pkgs.gtk3
    distro
    openpaperwork-core
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeBuildInputs = [ pkgs.gettext pkgs.which ];
  preBuild = ''
    make l10n_compile
  '';

  checkInputs = [ openpaperwork-gtk psutil ];

  meta = {
    description = "Backend part of Paperwork (Python API, no UI)";
    homepage = "https://openpaper.work/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aszlig symphorien ];
  };
}
