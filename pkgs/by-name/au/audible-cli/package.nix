{
  lib,
  python3Packages,
  fetchFromGitHub,
  addBinToPathHook,
  installShellFiles,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "audible-cli";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkb79";
    repo = "audible-cli";
    tag = "v${version}";
    hash = "sha256-DGOOMjP6dxIwbIhzRKf0+oy/2Cs+00tpwHkcmrukatw=";
  };

  nativeBuildInputs =
    with python3Packages;
    [
      setuptools
    ]
    ++ [
      addBinToPathHook
      installShellFiles
    ];

  propagatedBuildInputs = with python3Packages; [
    aiofiles
    audible
    click
    httpx
    packaging
    pillow
    questionary
    setuptools
    tabulate
    toml
    tqdm
  ];

  pythonRelaxDeps = [
    "httpx"
  ];

  postInstall = ''
    installShellCompletion --cmd audible \
      --bash <(source utils/code_completion/audible-complete-bash.sh) \
      --fish <(source utils/code_completion/audible-complete-zsh-fish.sh) \
      --zsh <(source utils/code_completion/audible-complete-zsh-fish.sh)
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

  meta = with lib; {
    description = "Command line interface for audible package. With the cli you can download your Audible books, cover, chapter files";
    license = licenses.agpl3Only;
    homepage = "https://github.com/mkb79/audible-cli";
    changelog = "https://github.com/mkb79/audible-cli/blob/${src.rev}/CHANGELOG.md";
    maintainers = with maintainers; [ jvanbruegge ];
    mainProgram = "audible";
  };
}
