{
  lib,
  python3Packages,
  fetchFromGitHub,
  qt5,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "git-annex-metadata-gui";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alpernebbi";
    repo = "git-annex-metadata-gui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VU2d0ls4XOzj2jgqBISdS3FODHoGpBOQZjRhMI+BbA4=";
  };

  prePatch = ''
    substituteInPlace setup.py --replace "'PyQt5', " ""
  '';

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = [
    python3Packages.pyqt5
    python3Packages.git-annex-adapter
  ];

  meta = {
    homepage = "https://github.com/alpernebbi/git-annex-metadata-gui";
    description = "Graphical interface for git-annex metadata commands";
    mainProgram = "git-annex-metadata-gui";
    maintainers = with lib.maintainers; [
      dotlambda
      matthiasbeyer
    ];
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux;
  };
})
