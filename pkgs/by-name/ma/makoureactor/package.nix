{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  ff7tk,
  zlib,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "makoureactor";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "myst6re";
    repo = "makoureactor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iRRR7cL/0ZjRaewn4wD7r/FRh7niJRAKXjdFGvz6noI=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    ff7tk
    qt6.qt5compat
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    zlib
  ];

  cmakeFlags = [ (lib.cmakeBool "CLI" true) ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/makoureactor";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Final Fantasy VII field archive editor";
    homepage = "https://github.com/myst6re/makoureactor";
    changelog = "https://github.com/myst6re/makoureactor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "Makou_Reactor";
    platforms = lib.platforms.linux;
  };
})
