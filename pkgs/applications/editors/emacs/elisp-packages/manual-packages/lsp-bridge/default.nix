{
  lib,
  python3,
  melpaBuild,
  fetchFromGitHub,
  replaceVars,
  fetchpatch,
  acm,
  markdown-mode,
  basedpyright,
  git,
  go,
  gopls,
  tempel,
  unstableGitUpdater,
  writableTmpDirAsHomeHook,
}:

let
  python = python3.withPackages (
    ps: with ps; [
      epc
      orjson
      packaging
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
  version = "0-unstable-2025-11-13";

  src = fetchFromGitHub {
    owner = "manateelazycat";
    repo = "lsp-bridge";
    rev = "426794a45b57d923129dfa1e4ca07c34aa72e69c";
    hash = "sha256-9nNg0yCtEBFNWP7TFGo1SsmtnnufoROyaeIJK0tjoEQ=";
  };

  patches = [
    # Hardcode the python dependencies needed for lsp-bridge, so users
    # don't have to modify their global environment
    (replaceVars ./hardcode-dependencies.patch {
      python = python.interpreter;
    })

    # Revert using quelpa repo to get check inputs
    (fetchpatch {
      url = "https://github.com/manateelazycat/lsp-bridge/commit/a999c8432817a806ed9ad74b5e918ab9612bd09b.patch";
      revert = true;
      hash = "sha256-NK6hooWn78Hk26tcQbIwUiiJuQ/hhlbLK+pgiZT//fI=";
    })
  ];

  packageRequires = [
    acm
    markdown-mode
  ];

  checkInputs = [
    # Emacs packages
    tempel
  ];

  nativeCheckInputs = [
    # Executables
    basedpyright
    git
    go
    gopls
    python
    writableTmpDirAsHomeHook
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
    python -m test.test

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
