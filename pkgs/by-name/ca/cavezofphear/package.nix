{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  help2man,
  ncurses,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cavezofphear";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "AMDmi3";
    repo = "cavezofphear";
    tag = finalAttrs.version;
    hash = "sha256-SiwJJOwCsKtZPri+aBuuMvF0ZCmLECQzkX1U/B3GVPQ=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    help2man
  ];

  buildInputs = [ ncurses ];

  cmakeFlags = [
    (lib.cmakeBool "SYSTEMWIDE" true)
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Console Boulder Dash / Digger-like game";
    homepage = "https://github.com/AMDmi3/cavezofphear";
    changelog = "https://github.com/AMDmi3/cavezofphear/blob/master/ChangeLog.md";
    license = lib.licenses.gpl3Plus;
    mainProgram = "phear";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})
