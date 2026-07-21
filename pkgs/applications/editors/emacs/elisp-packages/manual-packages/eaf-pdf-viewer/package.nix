{
  # Basic
  lib,
  melpaBuild,
  fetchFromGitHub,
  # Updater
  unstableGitUpdater,
}:

melpaBuild {

  pname = "eaf-pdf-viewer";
  version = "0-unstable-2025-07-26";

  src = fetchFromGitHub {
    owner = "emacs-eaf";
    repo = "eaf-pdf-viewer";
    rev = "ff08a6b48faac2d231fb1cfe968cec7e41bbeb98";
    hash = "sha256-7JAWgCECHnMGPH9GM8pi9lDzR+B4T6xgYQCor032zbM=";
  };

  files = ''
    ("*.el"
     "*.py")
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
    eafPythonDeps =
      ps: with ps; [
        packaging
        pymupdf
      ];
  };

  meta = {
    description = "Fastest PDF Viewer in Emacs";
    homepage = "https://github.com/emacs-eaf/eaf-pdf-viewer";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      thattemperature
    ];
  };

}
