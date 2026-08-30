{
  # Basic
  lib,
  melpaBuild,
  fetchFromGitHub,
  # Updater
  unstableGitUpdater,
}:

melpaBuild {

  pname = "eaf-airshare";
  version = "0-unstable-2023-07-11";

  src = fetchFromGitHub {
    owner = "emacs-eaf";
    repo = "eaf-airshare";
    rev = "71b4507ad5724babcf34da941a53c5a94bf7666a";
    hash = "sha256-jpODlbg/luuCuDOayBqhVCF3vXww2FolYLniykeZr6E=";
  };

  files = ''
    ("*.el"
     "*.py")
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
    eafPythonDeps =
      ps:
      with ps;
      [
        qrcode
      ]
      ++ ps.qrcode.optional-dependencies.pil;
  };

  meta = {
    description = "Share text by qr-code in Emacs";
    homepage = "https://github.com/emacs-eaf/eaf-airshare";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      thattemperature
    ];
  };

}
