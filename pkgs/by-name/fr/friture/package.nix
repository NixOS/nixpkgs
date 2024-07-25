{
  lib,
  fetchFromGitHub,
  python3Packages,
  qt5,
}:

python3Packages.buildPythonApplication rec {
  pname = "friture";
  version = "0.49-unstable-2024-06-02";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tlecomte";
    repo = pname;
    rev = "405bffa585ece0cb535c32d0f4f6ace932b40103";
    hash = "sha256-4xvIlRuJ7WCFj1dEyvO9UOsye70nFlWjb9XU0owwgiM=";
  };

  pythonRelaxDeps = true;

  postPatch = ''
    sed -i -e '/packages=\[/a "friture.playback",' pyproject.toml
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
      alyaeanyx
    ];
  };
}
