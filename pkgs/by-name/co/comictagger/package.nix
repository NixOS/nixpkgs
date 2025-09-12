{
  fetchPypi,
  imagemagick,
  lib,
  nix-update-script,
  python3Packages,
  qt5,
  stdenvNoCC,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "comictagger";
  version = "1.5.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f/SS6mo5zIcNBN/FRMhRPMNOeB1BIqBhsAogjsmdjB0=";
  };

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    versionCheckHook
    imagemagick
  ];

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    beautifulsoup4
    importlib-metadata
    natsort
    pathvalidate
    pillow
    py7zr
    pycountry
    pyicu
    pyqt5
    requests
    text2digits
    thefuzz
    typing-extensions
    unrar2-cffi # drop this when updating ComicTagger to version 1.6.0
    wordninja
  ];

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [ qt5.qtwayland ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTests = [
    # Seven7zipArchiver test fails: Error reading in raw CIX!
    "test_copy_from_archive"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  dontWrapQtApps = true;

  postInstall = ''
    for size in 16 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick convert -resize "$size"x"$size" comictaggerlib/graphics/app.png $out/share/icons/hicolor/"$size"x"$size"/apps/ComicTagger.png
    done
    install -D --mode=0644 --target-directory=$out/share/applications/ desktop-integration/linux/ComicTagger.desktop
    substituteInPlace $out/share/applications/ComicTagger.desktop \
      --replace-fail "Exec=%%CTSCRIPT%% %F" "Exec=comictagger %F" \
      --replace-fail "Icon=/usr/local/share/comictagger/app.png" "Icon=ComicTagger"
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = {
    description = "Multi-platform app for writing metadata to digital comics";
    homepage = "https://github.com/comictagger/comictagger";
    changelog = "https://github.com/comictagger/comictagger/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = with lib.platforms; darwin ++ linux ++ windows;
    broken = !stdenvNoCC.hostPlatform.isLinux; # Not tested on other platforms.
    maintainers = with lib.maintainers; [ jwillikers ];
    mainProgram = "comictagger";
  };
}
