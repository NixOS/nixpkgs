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
  version = "0-unstable-2025-08-13";

  src = fetchFromGitHub {
    owner = "manateelazycat";
    repo = "holo-layer";
    rev = "6584d8057a264f199e0cf6e90095fa63d36e6049";
    hash = "sha256-80uGyQltHBtrEtG/hkhHP5qbBfShw5BDyfR3GUHlhJk=";
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
