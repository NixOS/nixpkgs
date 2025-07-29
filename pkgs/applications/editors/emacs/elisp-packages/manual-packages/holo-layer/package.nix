{
  # Basic
  lib,
  melpaBuild,
  fetchFromGitHub,
  # Python dependency
  python3,
  # Emacs dependencies
  markdown-mode,
  posframe,
  # Updater
  unstableGitUpdater,
}:

let

  pythonPkgs =
    ps: with ps; [
      epc
      inflect
      pyqt6
      pyqt6-sip
      sexpdata
      six
      xlib
    ];
  pythonEnv = python3.withPackages pythonPkgs;

in

melpaBuild {

  pname = "holo-layer";
  version = "0-unstable-2025-06-13";

  src = fetchFromGitHub {
    owner = "manateelazycat";
    repo = "holo-layer";
    rev = "464b6996268a81fa3b524ced02a60fcc266f8965";
    hash = "sha256-uTxfnhtDybWx+Na4fj5TJuZh+tKoNuSZ03IR9ErvI7s=";
  };

  packageRequires = [
    markdown-mode
    posframe
  ];

  postPatch = ''
    substituteInPlace holo-layer.el \
      --replace-fail "\"python3\"" \
                     "\"${pythonEnv.interpreter}\""
  '';

  files = ''
    ("*.el"
     "*.py"
     "icon_cache"
     "plugin"
     "resources"
     "swaymsg-treefetch")
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Display and animation extension for Emacs";
    homepage = "https://github.com/manateelazycat/holo-layer";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      thattemperature
    ];
  };

}
