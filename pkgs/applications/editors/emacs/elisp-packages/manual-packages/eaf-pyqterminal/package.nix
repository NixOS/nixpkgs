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
  version = "0-unstable-2025-05-05";

  src = fetchFromGitHub {
    owner = "mumu-lhl";
    repo = "eaf-pyqterminal";
    rev = "db947f136660adc4c3883b332f4465af82e4c9da";
    hash = "sha256-0BH29XvBzJPgJBFSKHiKSLo/dpj5rixg7+u+LDpB5+U=";
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
