{
  melpaBuild,
  fetchFromGitHub,
  git,
  unstableGitUpdater,
  lib,
}:

melpaBuild rec {
  pname = "elpaca";
  version = "0-unstable-2025-11-06";

  src = fetchFromGitHub {
    owner = "progfolio";
    repo = "elpaca";
    rev = "b5ef5f19ac1224853234c9acdac0ec9ea1c440a1";
    hash = "sha256-EZ9emYTweRZzMKxZu9nbAaGgE2tInaL7KCKvJ5TaD0g=";
  };

  nativeBuildInputs = [ git ];

  # Moves extensions into the source root directory to install them.
  # Disables warnings related to being used with package.el and not matching the installer
  # Points the elpaca-repos-directory to the installed package in the nix store
  postPatch =
    let
      siteVersion = lib.concatStrings (lib.drop 2 (lib.splitVersion version));
    in
    ''
      mv extensions/* .
      substituteInPlace elpaca.el \
        --replace-fail "lwarn '(elpaca installer)" \
                       "ignore '(elpaca installer)" \
        --replace-fail "warn \"Package.el" \
                       "ignore \"Package.el" \
        --replace-fail "(expand-file-name \"elpaca/\" elpaca-repos-directory)" \
                       "\"${placeholder "out"}/share/emacs/site-lisp/elpa/elpaca-${siteVersion}.0\""
    '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Elisp package manager and replacement for package.el";
    longDescription = ''
      Elpaca is an elisp package manager. It allows users to find,
      install, update, and remove third-party packages for Emacs. It
      is a replacement for the built-in Emacs package manager,
      package.el.

      Elpaca:
       - Installs packages asynchronously, in parallel for fast, non-blocking installations.
       - Includes a flexible UI for finding and operating on packages.
       - Downloads packages from their sources for convenient elisp development.
       - Supports thousands of elisp packages out of the box (MELPA, NonGNU/GNU ELPA, Org/org-contrib).
       - Makes it easy for users to create their own ELPAs.

      Elpaca has been adapted for Emacs managed via Nix. To activate
      Elpaca, this snippet can be used within your init.el:

      ```elisp
      (add-hook 'after-init-hook #'elpaca-process-queues)
      (elpaca-use-package-mode) ;; Optional, for use-package support
      ```
    '';
    homepage = "https://github.com/progfolio/elpaca";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      abhisheksingh0x558
      normalcea
    ];
  };
}
