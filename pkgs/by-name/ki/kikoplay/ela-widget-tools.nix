{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
  qt6,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ela-widget-tools";
  version = "0-unstable-2025-10-11";
  src = fetchFromGitHub {
    owner = "Liniyous";
    repo = "ElaWidgetTools";
    rev = "27ce9e529a79e48af1d20acff6b60820126cc28c";
    hash = "sha256-fxXY9ONvZEW3G839BdFNeRHRAYeQg3Dl8XNQjvB34Dk=";
  };

  patches = [ ./ela-widget-tools-fix-install-path.patch ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
  ];

  postInstall = ''
    cp -r $out/ElaWidgetTools/* $out/
    rm -rf $out/ElaWidgetTools
  '';

  meta = {
    mainProgram = "ElaWidgetToolsExample";
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Fluent-UI For QT-Widget";
    homepage = "https://github.com/Liniyous/ElaWidgetTools";
    license = lib.licenses.mit;
  };
})
