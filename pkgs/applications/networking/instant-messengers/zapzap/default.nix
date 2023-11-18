{ lib
, fetchFromGitHub
, buildPythonApplication
, setuptools
, pyqt6
, pyqt6-webengine
, dbus-python
}:

buildPythonApplication rec {
  pname = "zapzap";
  version = "4.5.5.2";

  src = fetchFromGitHub {
    owner = "zapzap-linux";
    repo = "zapzap";
    rev = version;
    hash = "sha256-8IeFGTI+5kbeFGqH5DpHCY8pqzGhE48hPCEIKIe7jAM=";
  };

  propagatedBuildInputs = [
    setuptools
    dbus-python
    pyqt6
    pyqt6-webengine
  ];

  prePatch = "export HOME=$NIX_BUILD_TOP";

  installPhase = ''
    python setup.py install --prefix=$out
    mkdir -p $out/usr/share/applications
    cp -R share/applications/com.rtosta.zapzap.desktop $out/usr/share/applications/com.rtosta.zapzap.desktop
    mkdir -p $out/usr/share/icons/hicolor/scalable/apps/
    cp -R share/icons/com.rtosta.zapzap.svg $out/usr/share/icons/hicolor/scalable/apps/com.rtosta.zapzap.svg
  '';

  meta = with lib; {
    description = "WhatsApp desktop application for Linux ";
    homepage = "https://zapzap-linux.github.io/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.eymeric ];
  };
}


