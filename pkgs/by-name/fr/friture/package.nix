{
  lib,
  fetchFromGitHub,
  python3Packages,
  qt5,
}:

python3Packages.buildPythonApplication rec {
  pname = "friture";
<<<<<<< HEAD
  version = "0.54";
=======
  version = "0.51";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tlecomte";
    repo = "friture";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-KWj2AhPloomjYwd7besX5QIG8snZe1L2hATEfm/HaIE=";
=======
    hash = "sha256-1Swkk7bhQTSo17Gj0i1VNiIt+fSXgDIeWfJ9LpoUEHg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    platformdirs
    pyinstaller
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Real-time audio analyzer";
    mainProgram = "friture";
    homepage = "https://friture.org/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux; # fails on Darwin
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Real-time audio analyzer";
    mainProgram = "friture";
    homepage = "https://friture.org/";
    license = licenses.gpl3;
    platforms = platforms.linux; # fails on Darwin
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      laikq
      pentane
    ];
  };
}
