{ lib
, python3
, melpaBuild
, fetchFromGitHub
, substituteAll
, acm
, markdown-mode
, posframe
, git
, go
, gopls
, pyright
<<<<<<< HEAD
, ruff
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, tempel
, writeText
, unstableGitUpdater
}:

let
<<<<<<< HEAD
  rev = "6f93deb32ebb3799dfedd896a17a0428a9b461bb";
=======
  rev = "7e1e6a4c349e720d75c892cd7230b29c35148342";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  python = python3.withPackages (ps: with ps; [
    epc
    orjson
    sexpdata
    six
  ]);
in
melpaBuild {
  pname = "lsp-bridge";
<<<<<<< HEAD
  version = "20230607.135"; # 1:35 UTC
=======
  version = "20230424.1642"; # 16:42 UTC
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "manateelazycat";
    repo = "lsp-bridge";
    inherit rev;
<<<<<<< HEAD
    hash = "sha256-4AKKsU+yuLA9qv6mhYPpjBJ8wrbGPMuzN98JXcVPAHg=";
=======
    sha256 = "sha256-e0XVQpsyjy8HeZN6kLRjnoTpyEefTqstsgydEKlEQ1c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  commit = rev;

<<<<<<< HEAD
  patches = [
    # Hardcode the python dependencies needed for lsp-bridge, so users
    # don't have to modify their global environment
    (substituteAll {
      src = ./hardcode-dependencies.patch;
      python = python.interpreter;
    })
  ];
=======
  # Hardcode the python dependencies needed for lsp-bridge, so users
  # don't have to modify their global environment
  postPatch = ''
    substituteInPlace lsp-bridge.el --replace \
     '(defcustom lsp-bridge-python-command (if (memq system-type '"'"'(cygwin windows-nt ms-dos)) "python.exe" "python3")' \
     '(defcustom lsp-bridge-python-command "${python.interpreter}"'
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  packageRequires = [
    acm
    markdown-mode
    posframe
  ];

<<<<<<< HEAD
=======
  buildInputs = [ python ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  checkInputs = [
    git
    go
    gopls
    pyright
<<<<<<< HEAD
    python
    ruff
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    tempel
  ];

  recipe = writeText "recipe" ''
    (lsp-bridge
      :repo "manateelazycat/lsp-bridge"
      :fetcher github
      :files
      ("*.el"
       "lsp_bridge.py"
       "core"
       "langserver"
       "multiserver"
       "resources"))
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    cd "$sourceRoot"
    mkfifo test.log
    cat < test.log &
    HOME=$(mktemp -d) python -m test.test

    runHook postCheck
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A blazingly fast LSP client for Emacs";
    homepage = "https://github.com/manateelazycat/lsp-bridge";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fxttr kira-bruneau ];
  };
}
