{
  # Basic
  lib,
  melpaBuild,
  fetchFromGitHub,
  # Updater
  unstableGitUpdater,
}:

{

  app = melpaBuild {

    pname = "eaf-pdf-viewer";
    version = "0-unstable-2025-06-14";

    src = fetchFromGitHub {
      owner = "emacs-eaf";
      repo = "eaf-pdf-viewer";
      rev = "96fa83176f17a33e516bdb4e0abaa832e3328248";
      hash = "sha256-JEvIw9JL4P6+za9twhSBDlHLC3VABiR/Ovqjww8jU8E=";
    };

    files = ''
      ("*.el"
       "*.py")
    '';

    passthru.updateScript = unstableGitUpdater { };

    meta = {
      description = "Fastest PDF Viewer in Emacs";
      homepage = "https://github.com/emacs-eaf/eaf-pdf-viewer";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [
        thattemperature
      ];
    };

  };

  pythonDeps =
    ps: with ps; [
      packaging
      pymupdf
    ];

  otherDeps = pkgs: [ ];

}
