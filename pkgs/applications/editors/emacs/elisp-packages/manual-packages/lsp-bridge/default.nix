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
, ruff
, tempel
, writeText
, unstableGitUpdater
}:

let
  rev = "a3d67c80eb4a3f4ed17d6a4e90f142b8c22ae7ee";
  python = python3.withPackages (ps: with ps; [
    epc
    orjson
    sexpdata
    six
  ]);
in
melpaBuild {
  pname = "lsp-bridge";
  version = "20230929.1113"; # 11:13 UTC

  src = fetchFromGitHub {
    owner = "manateelazycat";
    repo = "lsp-bridge";
    inherit rev;
    hash = "sha256:10ryn6a6f3akphzwf66c3xlqlxd7k5g0703j45aza3j376g6fd03";
  };

  commit = rev;

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
    posframe
  ];

  checkInputs = [
    git
    go
    gopls
    pyright
    python
    ruff
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
