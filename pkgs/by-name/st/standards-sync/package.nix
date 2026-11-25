# The nixpkgs expression (pkgs/by-name/st/standards-sync/package.nix),
# built from the PyPI sdist; CI builds it with callPackage against nixpkgs.
{
  lib,
  python3Packages,
  fetchPypi,
  installShellFiles,
  git,
}:

python3Packages.buildPythonApplication rec {
  pname = "standards-sync";
  version = "0.0.15";
  pyproject = true;

  src = fetchPypi {
    pname = "standards_sync";
    inherit version;
    hash = "sha256-DVb0d8Gq0NhODLTf9BNiAoQ+NzvtYJoosW9ANNzoD5c=";
  };

  build-system = [ python3Packages.hatchling ];

  nativeBuildInputs = [
    installShellFiles
    python3Packages.argparse-manpage
    python3Packages.shtab
  ];

  # The sync check compares against every version the standards repository
  # committed, with git.
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ git ])
  ];

  postInstall = ''
    argparse-manpage --pyfile scripts/sync.py --function build_parser \
      --prog standards-sync --project-name standards --version ${version} \
      --author "Sebastien Rousseau" --manual-title "standards-sync manual" \
      --description "keep the code standards in sync" \
      --url ${meta.homepage} --output standards-sync.1
    installManPage standards-sync.1
    for shell in bash zsh; do
      PYTHONPATH=scripts shtab --shell=$shell --prog standards-sync sync.build_parser > standards-sync.$shell
    done
    installShellCompletion --cmd standards-sync --bash standards-sync.bash --zsh standards-sync.zsh
    # Only newer shtab releases write fish completions; nixpkgs 26.05's cannot.
    if shtab --help | grep -q fish; then
      PYTHONPATH=scripts shtab --shell=fish --prog standards-sync sync.build_parser > standards-sync.fish
      installShellCompletion --cmd standards-sync --fish standards-sync.fish
    fi
  '';

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    python3Packages.hypothesis
    git
  ];

  enabledTestPaths = [
    "tests/test_sync.py"
    "fuzz/test_fuzz_sync.py"
  ];

  pythonImportsCheck = [ "standards_sync" ];

  meta = {
    description = "Keep the code standards in sync without losing edits";
    homepage = "https://github.com/sebastienrousseau/standards";
    changelog = "https://github.com/sebastienrousseau/standards/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ sebastienrousseau ];
    mainProgram = "standards-sync";
  };
}
