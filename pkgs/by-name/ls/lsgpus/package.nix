{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lsgpus";
  version = "0.2.6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AGuyMarc";
    repo = "lsgpu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IQoZ55WNZdqwq1w23P1Oy4badJvxv69RUTQ7xM/+EJI=";
  };

  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage lsgpus.1
  '';

  # The Python module is "lsgpu"; the installed program is "lsgpus"
  # ("lsgpu" is already taken by /usr/bin/lsgpu from igt-gpu-tools).
  pythonImportsCheck = [ "lsgpu" ];

  # The unittest suite only invokes the script itself (--help/--version) and
  # mocks everything else, so it runs without a GPU or nvidia-smi/rocm-smi.
  nativeCheckInputs = [ python3Packages.unittestCheckHook ];
  unittestFlagsArray = [
    "-s"
    "tests"
    "-v"
  ];

  meta = {
    description = "List GPUs with details — like lscpu/lsusb but for graphics cards";
    homepage = "https://github.com/AGuyMarc/lsgpu";
    changelog = "https://github.com/AGuyMarc/lsgpu/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    mainProgram = "lsgpus";
    maintainers = with lib.maintainers; [ guy-marc-aprin ];
    platforms = lib.platforms.linux;
  };
})
