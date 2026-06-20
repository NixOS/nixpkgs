{
  lib,
  fetchFromGitHub,
  python3Packages,
  qt5,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "friture";
  version = "0.54";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tlecomte";
    repo = "friture";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KWj2AhPloomjYwd7besX5QIG8snZe1L2hATEfm/HaIE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy==2.3.2" "numpy" \
      --replace-fail "Cython==3.1.3" "Cython"
  '';

  nativeBuildInputs =
    (with python3Packages; [
      numpy
      cython
      scipy
      setuptools
    ])
    ++ (with qt5; [ wrapQtAppsHook ]);

  # Very strict versions
  pythonRelaxDeps = true;

  # Not actually used, dropped from nixpkgs
  pythonRemoveDeps = [ "pyrr" ];

  buildInputs = with qt5; [ qtquickcontrols2 ];

  propagatedBuildInputs = with python3Packages; [
    platformdirs
    pyinstaller
    sounddevice
    pyopengl
    pyopengl-accelerate
    docutils
    numpy
    pyqt5
    appdirs
    rtmixer
  ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  postInstall = ''
    substituteInPlace $out/share/applications/friture.desktop --replace-fail usr/bin/friture friture

    for size in 16 32 128 256 512
    do
      mkdir -p $out/share/icons/hicolor/$size\x$size
      cp $src/resources/images/friture.iconset/icon_$size\x$size.png $out/share/icons/hicolor/$size\x$size/friture.png
    done
    mkdir -p $out/share/icons/hicolor/scalable/apps/
    cp $src/resources/images-src/window-icon.svg $out/share/icons/hicolor/scalable/apps/friture.svg
  '';

  meta = {
    description = "Real-time audio analyzer";
    mainProgram = "friture";
    homepage = "https://friture.org/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux; # fails on Darwin
    maintainers = with lib.maintainers; [
      laikq
      pentane
    ];
  };
})
