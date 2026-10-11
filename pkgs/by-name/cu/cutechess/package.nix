{
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  versionCheckHook,
  nix-update-script,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cutechess";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "cutechess";
    repo = "cutechess";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FbLYAvEb5g63T4Hp4MDY4uyZWdJdd46bOqC8c4GI7cw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qt5compat
  ];

  doCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/cutechess-cli";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GUI, CLI, and library for playing chess";
    homepage = "https://cutechess.com/";
    changelog = "https://github.com/cutechess/cutechess/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kangazero ];
    platforms = with lib.platforms; (linux ++ windows);
    mainProgram = "cutechess";
  };
})
