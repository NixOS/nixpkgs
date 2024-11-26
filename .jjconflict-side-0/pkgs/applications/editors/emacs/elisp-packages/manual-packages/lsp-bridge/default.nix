{
  lib,
  python3,
  melpaBuild,
  fetchFromGitHub,
  substituteAll,
  acm,
  markdown-mode,
  basedpyright,
  git,
  go,
  gopls,
  tempel,
  unstableGitUpdater,
}:

let
  python = python3.withPackages (
    ps: with ps; [
      epc
      orjson
      paramiko
      rapidfuzz
      setuptools
      sexpdata
      six
      watchdog
    ]
  );
in
melpaBuild {
  pname = "lsp-bridge";
  version = "0-unstable-2024-12-09";

  src = fetchFromGitHub {
    owner = "manateelazycat";
    repo = "lsp-bridge";
    rev = "520d253a00d360d7aa47d85a9c4a99ea6702acde";
    hash = "sha256-NQ7lkTC8JGfMAsDA//Zj8IGV03b2frOuHuvjRSVNGXE=";
  };

  patches = [
    # Hardcode the python dependencies needed for lsp-bridge, so users
    # don't have to modify their global environment
    (substituteAll {
      src = ./hardcode-dependencies.patch;
      python = python.interpreter;
    })
  ];

  packageRequires = [
    acm
    markdown-mode
  ];

  checkInputs = [
    # Emacs packages
    tempel

    # Executables
    basedpyright
    git
    go
    gopls
    python
  ];

  files = ''
    ("*.el"
     "lsp_bridge.py"
     "core"
     "langserver"
     "multiserver"
     "resources")
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    mkfifo test.log
    cat < test.log &
    HOME=$(mktemp -d) python -m test.test

    runHook postCheck
  '';

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Blazingly fast LSP client for Emacs";
    homepage = "https://github.com/manateelazycat/lsp-bridge";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      fxttr
      kira-bruneau
    ];
  };
}
