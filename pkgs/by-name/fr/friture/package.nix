{
  lib,
  fetchFromGitHub,
  python3Packages,
  qt5,
}:

python3Packages.buildPythonApplication rec {
  pname = "friture";
  version = "0.54";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tlecomte";
    repo = "friture";
    rev = "v${version}";
    hash = "sha256-KWj2AhPloomjYwd7besX5QIG8snZe1L2hATEfm/HaIE=";
  };

  postPatch = ''
    sed -i -e 's/==.*"/"/' -e '/packages=\[/a "friture.playback",' pyproject.toml
    sed -i -e 's/tostring/tobytes/' friture/spectrogram_image.py
  '';

  nativeBuildInputs =
    (with python3Packages; [
      numpy
      cython
      scipy
      setuptools
    ])
    ++ (with qt5; [ wrapQtAppsHook ]);

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
    pyrr
    rtmixer
  ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  postInstall = ''
    substituteInPlace $out/share/applications/friture.desktop --replace usr/bin/friture friture

    for size in 16 32 128 256 512
    do
      mkdir -p $out/share/icons/hicolor/$size\x$size
      cp $src/resources/images/friture.iconset/icon_$size\x$size.png $out/share/icons/hicolor/$size\x$size/friture.png
    done
    mkdir -p $out/share/icons/hicolor/scalable/apps/
    cp $src/resources/images-src/window-icon.svg $out/share/icons/hicolor/scalable/apps/friture.svg
  '';

  meta = with lib; {
    description = "Real-time audio analyzer";
    mainProgram = "friture";
    homepage = "https://friture.org/";
    license = licenses.gpl3;
    platforms = platforms.linux; # fails on Darwin
    maintainers = with maintainers; [
      laikq
      pentane
    ];
  };
}
