{ lib
, python3
, melpaBuild
, fetchFromGitHub
, substituteAll
, acm
, markdown-mode
, git
, go
, gopls
, pyright
, ruff
, tempel
, writeScript
, writeText
}:

let
  rev = "f48de0896d3af80f5e15aef512b7485eb46df9f6";
  python = python3.withPackages (ps: with ps; [
    epc
    orjson
    paramiko
    rapidfuzz
    sexpdata
    six
  ]);
in
melpaBuild {
  pname = "lsp-bridge";
  version = "20240601.1149";

  src = fetchFromGitHub {
    owner = "manateelazycat";
    repo = "lsp-bridge";
    inherit rev;
    hash = "sha256-ocKNRSt5RVKGnxd0odI43jdr27oYrRLdnABh6x63CfM=";
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

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p common-updater-scripts coreutils git gnused
    set -eu -o pipefail

    tmpdir="$(mktemp -d)"
    git clone --depth=1 https://github.com/manateelazycat/lsp-bridge.git "$tmpdir"

    pushd "$tmpdir"
    commit=$(git show -s --pretty='format:%H')
    # Based on: https://github.com/melpa/melpa/blob/2d8716906a0c9e18d6c979d8450bf1d15dd785eb/package-build/package-build.el#L523-L533
    version=$(TZ=UTC git show -s --pretty='format:%cd' --date='format-local:%Y%m%d.%H%M' | sed 's|\.0*|.|')
    popd

    update-source-version emacsPackages.lsp-bridge $version --rev="$commit"
  '';

  meta = with lib; {
    description = "Blazingly fast LSP client for Emacs";
    homepage = "https://github.com/manateelazycat/lsp-bridge";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fxttr kira-bruneau ];
  };
}
