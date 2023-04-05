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
  rev = "c5dc02f6bd47039c320083b3befac0e569c0efa4";
  python = python3.withPackages (ps: with ps; [
    epc
    orjson
    sexpdata
    six
  ]);
in
melpaBuild {
  pname = "lsp-bridge";
  version = "20230311.1648"; # 16:48 UTC

  src = fetchFromGitHub {
    owner = "manateelazycat";
    repo = "lsp-bridge";
    inherit rev;
    sha256 = "sha256-vbSVGPFBjAp4VRbJc6a2W0d2IqOusNa+rk4X6jRcjRI=";
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
