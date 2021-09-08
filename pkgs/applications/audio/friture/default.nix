{ lib, fetchFromGitHub, python3Packages, wrapQtAppsHook }:

let
  py = python3Packages;
in py.buildPythonApplication rec {
  pname = "friture";
  version = "0.47";

  src = fetchFromGitHub {
    owner = "tlecomte";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qcsvmgdz9hhv5gaa918147wvng6manc4iq8ci6yr761ljqrgwjx";
  };

  nativeBuildInputs = (with py; [ numpy cython scipy ]) ++
    [ wrapQtAppsHook ];

  propagatedBuildInputs = with py; [
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

  patches = [
    ./unlock_constraints.patch
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
    description = "A real-time audio analyzer";
    homepage = "https://friture.org/";
    license = licenses.gpl3;
    platforms = platforms.linux; # fails on Darwin
    maintainers = [ maintainers.laikq ];
  };
}
