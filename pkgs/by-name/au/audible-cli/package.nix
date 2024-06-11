{ lib, python3Packages, fetchFromGitHub, installShellFiles, nix-update-script }:

python3Packages.buildPythonApplication rec {
  pname = "audible-cli";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkb79";
    repo = "audible-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-AYL7lcYYY7gK12Id94aHRWRlCiznnF4r+lpI5VFpAWY=";
  };

  nativeBuildInputs = with python3Packages; [
    pythonRelaxDepsHook
    setuptools
  ] ++ [
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
    export PATH=$out/bin:$PATH
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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Command line interface for audible package. With the cli you can download your Audible books, cover, chapter files";
    license = licenses.agpl3Only;
    homepage = "https://github.com/mkb79/audible-cli";
    changelog = "https://github.com/mkb79/audible-cli/blob/${src.rev}/CHANGELOG.md";
    maintainers = with maintainers; [ jvanbruegge ];
    mainProgram = "audible";
  };
}
