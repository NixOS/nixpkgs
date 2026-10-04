{
  lib,
  python3Packages,
  fetchFromGitHub,
  chntpw,
  versionCheckHook,
  nix-update-script,
  runCommand,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "bt-dualboot";
  version = "1.0.1";
  format = "pyproject";
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "x2es";
    repo = "bt-dualboot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/V94RMBseJ1fMe6YaCImHKYmwPzFNE+C5+xoiMj2Vl4=";
  };

  build-system = [ python3Packages.poetry-core ];
  dependencies = [ chntpw ];
  nativeBuildInputs = [ versionCheckHook ];

  pythonImportsCheck = [ "bt_dualboot" ];
  passthru.tests.help = runCommand "help" { } ''
    ${lib.getExe finalAttrs} --help >/dev/null
    touch $out
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sync Bluetooth for dualboot Linux and Windows";
    homepage = "https://github.com/x2es/bt-dualboot";
    license = lib.licenses.mit;
    mainProgram = "bt-dualboot";
    maintainers = [ lib.maintainers.bmrips ];
    platforms = lib.platforms.linux;
  };
})
