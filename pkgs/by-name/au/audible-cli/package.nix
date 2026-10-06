{
  lib,
  python3Packages,
  fetchFromGitHub,
  addBinToPathHook,
  installShellFiles,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "audible-cli";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkb79";
    repo = "audible-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GsPnnu7xwdcEM/Cj2jmRiDtUN3SSNmNFQrYbjXOfs0g=";
  };

  build-system = with python3Packages; [ hatchling ];

  nativeBuildInputs = [
    addBinToPathHook
    installShellFiles
  ];

  dependencies =
    with python3Packages;
    [
      aiofiles
      audible
      click
      httpx
      packaging
      pillow
      questionary
      tabulate
      toml
      tqdm
    ]
    ++ audible.optional-dependencies.cryptography;

  postInstall = ''
    installShellCompletion --cmd audible \
      --bash <(source utils/code_completion/audible-complete-bash.sh) \
      --zsh <(source utils/code_completion/audible-complete-zsh.sh) \
      --fish <(source utils/code_completion/audible-complete-fish.sh)
  '';

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "audible_cli"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v([0-9.]+)"
    ];
  };

  meta = {
    description = "Command line interface for audible package. With the cli you can download your Audible books, cover, chapter files";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/mkb79/audible-cli";
    changelog = "https://github.com/mkb79/audible-cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ jvanbruegge ];
    mainProgram = "audible";
  };
})
