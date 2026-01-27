{
  # Basic
  lib,
  melpaBuild,
  fetchFromGitHub,
  # Updater
  unstableGitUpdater,
}:

melpaBuild {

  pname = "eaf-pyqterminal";
  version = "0-unstable-2025-10-19";

  src = fetchFromGitHub {
    owner = "mumu-lhl";
    repo = "eaf-pyqterminal";
    rev = "37b7b2afbdd47c89d85ff6e3412e1dc6c555ab50";
    hash = "sha256-+RVA+UM473eTPrsX3TpUrzPx8UY5gAgIkMl0CB/iBTw=";
  };

  files = ''
    ("*.el"
     "*.py")
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
    eafPythonDeps =
      ps: with ps; [
        pyte
        psutil
      ];
  };

  meta = {
    description = "Terminal written in PyQt6 for the EAF";
    homepage = "https://github.com/mumu-lhl/eaf-pyqterminal";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      thattemperature
    ];
  };

}
