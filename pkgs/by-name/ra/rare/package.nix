{
  lib,
  fetchFromGitHub,
  qt6,
  legendary-gl,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rare";
  version = "1.12.0.237";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RareDevs";
    repo = "Rare";
    tag = finalAttrs.version;
    hash = "sha256-APca/YE3/tDZPxw+sV0CG2s8/zjCMgglBoHQm4YNxK8=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    qt6.qtbase
  ];

  propagatedBuildInputs = [
    legendary-gl
  ];

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    orjson
    pypresence
    pyside6
    qtawesome
    requests
    vdf
  ];

  dontWrapQtApps = true;

  postPatch = ''
    # PySide6-Essentials is a smaller version of PySide6, but the name mismatch breaks build
    substituteInPlace pyproject.toml \
      --replace-fail "PySide6-Essentials" "pyside6"
  '';

  postInstall = ''
    install -Dm644 packaging/rare.desktop -t $out/share/applications/
    install -Dm644 $out/${python3Packages.python.sitePackages}/rare/resources/images/Rare.png $out/share/icons/rare.png
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "GUI for Legendary, an Epic Games Launcher open source alternative";
    homepage = "https://github.com/RareDevs/Rare";
    maintainers = with lib.maintainers; [ VlaDexa ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "rare";
  };
})
