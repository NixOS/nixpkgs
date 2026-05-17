{
  lib,
  python3Packages,
  fetchFromGitHub,
  android-tools,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "better-adb-sync";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jb2170";
    repo = "better-adb-sync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ghOpcnQEZiAEZOiVWhrHa66WgiyyYQZgTJEokJFKMRs=";
  };

  build-system = with python3Packages; [ setuptools ];

  # The tool relies on the `adb` binary being available in the system
  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ android-tools ]}"
  ];

  pythonImportsCheck = [
    "BetterADBSync"
  ];

  meta = {
    description = "Synchronize files between a PC and an Android device using ADB (Android Debug Bridge)";
    homepage = "https://github.com/jb2170/better-adb-sync";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      lucc
      Misaka13514
    ];
    mainProgram = "adbsync";
  };
})
