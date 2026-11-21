{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "netcup-scp-cli";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "pavelpikta";
    repo = "netcup-scp-cli";
    tag = finalAttrs.version;
    hash = "sha256-dPZtaPRTUzFxjFJp5pYRTP00KRFOVd2eHiXMKTc0a7Q=";
  };
  __structuredAttrs = true;

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    click
    requests
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    responses
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/pavelpikta/netcup-scp-cli";
    changelog = "https://github.com/pavelpikta/netcup-cli/blob/main/CHANGELOG.md";
    description = "CLI for netcup SCP (Server Control Panel) REST API";
    license = lib.licenses.mit;
    mainProgram = "netcup";
    maintainers = with lib.maintainers; [ lykos153 ];
  };
})
