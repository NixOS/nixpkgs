{ lib, fetchFromGitHub, fetchpatch, python3Packages, wrapQtAppsHook }:

let
  py = python3Packages;
in py.buildPythonApplication rec {
  pname = "friture";
  version = "0.48";

  src = fetchFromGitHub {
    owner = "tlecomte";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oOH58jD49xAeSuP+l6tYUpwkYsnfeSGTt8x4DFzTY6g=";
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
    # Backported fix that resolves an issue with setuptools packaging
    (fetchpatch {
      name = "fix-setuptools-packaging.patch";
      url = "https://github.com/tlecomte/friture/commit/ea7210dae883edf17de8fec82f9428b18ee138b6.diff";
      sha256 = "sha256-Kv/vmC8kcqfOgfIPQyZN46sbV6bezhq6pyj8bvke6s8=";
    })
  ];

  postPatch = ''
    # Remove version constraints from Python dependencies in setup.py
    sed -i -E "s/\"([A-Za-z0-9]+)(=|>|<)=[0-9\.]+\"/\"\1\"/g" setup.py
  '';

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
    maintainers = with maintainers; [ laikq alyaeanyx ];
  };
}
