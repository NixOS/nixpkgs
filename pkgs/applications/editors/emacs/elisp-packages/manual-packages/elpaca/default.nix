{
  melpaBuild,
  fetchFromGitHub,
  git,
  unstableGitUpdater,
  lib,
}:

melpaBuild {
  pname = "elpaca";
  version = "0-unstable-2025-11-06";

  src = fetchFromGitHub {
    owner = "progfolio";
    repo = "elpaca";
    rev = "b5ef5f19ac1224853234c9acdac0ec9ea1c440a1";
    hash = "sha256-EZ9emYTweRZzMKxZu9nbAaGgE2tInaL7KCKvJ5TaD0g=";
  };

  nativeBuildInputs = [ git ];

  files = ''(:defaults "extensions/*.el")'';

  # elpaca uses a installer bootstrap via the user's init.el to install itself
  # https://github.com/progfolio/elpaca#installer
  #
  # elpaca checks to see if `elpaca-installer-version` variable is set
  # to a fixed value, this doesn't apply to nix since we don't use the
  # bootstrapped installer; silence this warning
  #
  # elpaca also checks if package.el loads before it, which in this
  # case, package.el always is and has to be. This does not affect
  # normal usage of elpaca with nix, other than packages installed
  # with elpaca will take precedence over packages installed via Nix
  # and imperatively installed via package.el; silence this warning.
  #
  # Since elpaca is not bootstrapped here, it cannot find itself in the
  # `elpaca-repos-directory` and so will fail to install any package.
  # Fix by substituting the `expand-file-name` s-exp to the string
  # filepath of elpaca's install location in the nix store.
  postPatch = ''
    substituteInPlace elpaca.el \
      --replace-fail "lwarn '(elpaca installer)" \
                     "ignore '(elpaca installer)" \
      --replace-fail "warn \"Package.el" \
                     "ignore \"Package.el" \
      --replace-fail "(expand-file-name \"elpaca/\" elpaca-repos-directory)" \
                     "\"${placeholder "out"}/share/emacs/site-lisp/elpa/$ename-$melpaVersion\""
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
    ];
  };
}
