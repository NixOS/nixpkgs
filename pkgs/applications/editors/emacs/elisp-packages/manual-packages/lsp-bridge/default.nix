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
, tempel
, writeText
, unstableGitUpdater
}:

let
  rev = "8de85f9967fec6a8e447e5b5f3021e5e1f95b445";
  python = python3.withPackages (ps: with ps; [
    epc
    orjson
    sexpdata
    six
  ]);
in
melpaBuild {
  pname = "lsp-bridge";
  version = "20230603.345"; # 3:45 UTC

  src = fetchFromGitHub {
    owner = "manateelazycat";
    repo = "lsp-bridge";
    inherit rev;
    sha256 = "sha256-08DFgZaYdlz9f9eqZuG760vpmO3D4QN9V66YqVyVsV4=";
  };

  commit = rev;

  # Hardcode the python dependencies needed for lsp-bridge, so users
  # don't have to modify their global environment
  postPatch = ''
    substituteInPlace lsp-bridge.el --replace \
     '(defcustom lsp-bridge-python-command (if (memq system-type '"'"'(cygwin windows-nt ms-dos)) "python.exe" "python3")' \
     '(defcustom lsp-bridge-python-command "${python.interpreter}"'
  '';

  packageRequires = [
    acm
    markdown-mode
    posframe
  ];

  buildInputs = [ python ];

  checkInputs = [
    git
    go
    gopls
    pyright
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
