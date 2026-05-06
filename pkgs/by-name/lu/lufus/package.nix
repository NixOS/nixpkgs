{
  lib,
  python313Packages,
  fetchFromGitHub,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:
python313Packages.buildPythonApplication (finalAttrs: {
  pname = "lufus";
  version = "1.0.0b1.1";

  src = fetchFromGitHub {
    owner = "Hog185";
    repo = "Lufus";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-3i0CnhGvLTXutz8CQoH5q4PwZ23lAwnUo8H5TRJx+KE=";
  };

  propagatedBuildInputs = with python313Packages; [
    psutil
    pyqt6
    pyudev
    requests
    platformdirs
  ];

  pyproject = true;

  build-system = with python313Packages; [
    setuptools
    wheel
  ];

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  __structuredAttrs = true;

  postInstall = ''
    makeWrapper ${python313Packages.python.interpreter} $out/bin/lufus \
      --add-flags "-m lufus" \
      --prefix PYTHONPATH : "$out/${python313Packages.python.sitePackages}:${python313Packages.makePythonPath finalAttrs.propagatedBuildInputs}"

    install -Dm644 src/lufus/gui/assets/lufus.png $out/share/pixmaps/lufus.png

    copyDesktopItems
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "lufus";
      desktopName = "Lufus";
      comment = "A rufus clone written in py and designed to work with linux";
      exec = "lufus";
      icon = "lufus";
      categories = [
        "Utility"
        "System"
      ];
    })
  ];

  meta = {
    description = "A rufus clone written in py and designed to work with linux";
    homepage = "https://github.com/Hog185/Lufus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Simon-Weij ];
    platforms = lib.platforms.linux;
    mainProgram = "lufus";
  };
})
