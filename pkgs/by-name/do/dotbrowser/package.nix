{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "dotbrowser";
  version = "0.5.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "xom11";
    repo = "dotbrowser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7mE5lA7y0nnQqACSGQjiRlcxIBslMHEbZ7htU2+ZyCI=";
  };

  build-system = with python3Packages; [ hatchling ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  disabledTests = [
    # touch the user's real on-disk Brave profile, unavailable in the sandbox
    "test_dump_real_profile_succeeds"
    "test_dry_run_apply_real_profile_does_not_write"
  ];

  pythonImportsCheck = [ "dotbrowser" ];

  meta = {
    description = "Manage browser settings as dotfiles (Brave, Vivaldi, Edge, Chrome)";
    homepage = "https://github.com/xom11/dotbrowser";
    changelog = "https://github.com/xom11/dotbrowser/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "dotbrowser";
    maintainers = with lib.maintainers; [ l3n4k4 ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
