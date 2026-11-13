{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "open-terminal";
  version = "0.14.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open-webui";
    repo = "open-terminal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6fnHCIdEJ3O7utV6limxAK5Dmsx0G/hjCyL2kCXz/jU=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies =
    with python3Packages;
    [
      aiofiles
      click
      fastapi
      httpx
      ipykernel
      nbclient
      openpyxl
      pypdf
      python-docx
      python-multipart
      python-pptx
      striprtf
      uvicorn
      xlrd
    ]
    ++ uvicorn.optional-dependencies.standard;

  # No python tests nor --version flag
  doCheck = false;

  pythonImportsCheck = [
    "open_terminal"
    "open_terminal.cli"
    "open_terminal.utils.notebooks"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Self-hosted remote terminal API for AI agents, used by Open WebUI";
    homepage = "https://github.com/open-webui/open-terminal";
    changelog = "https://github.com/open-webui/open-terminal/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      liberodark
      julm
    ];
    mainProgram = "open-terminal";
    platforms = lib.platforms.linux;
  };
})
