{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lsdisplay";
  version = "0.2.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AGuyMarc";
    repo = "lsdisplay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-69c33rZeLAuIDiFfoKLurSbfIOb6P7RLMVnp4DPgRCs=";
  };

  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage lsdisplay.1
  '';

  # Single-file pure-Python 3 program, no runtime dependencies.
  pythonImportsCheck = [ "lsdisplay" ];

  # The unittest suite only invokes the script itself (--help/--version) and
  # mocks everything else, so it runs without an X server.
  nativeCheckInputs = [ python3Packages.unittestCheckHook ];
  unittestFlagsArray = [
    "-s"
    "tests"
    "-v"
  ];

  meta = {
    description = "List connected displays — like lsusb/lspci but for screens";
    homepage = "https://github.com/AGuyMarc/lsdisplay";
    changelog = "https://github.com/AGuyMarc/lsdisplay/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    mainProgram = "lsdisplay";
    maintainers = with lib.maintainers; [ guy-marc-aprin ];
    platforms = lib.platforms.linux;
  };
})
