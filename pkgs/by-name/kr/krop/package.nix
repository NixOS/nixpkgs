{
  lib,
  python3Packages,
  fetchFromGitHub,
  libsForQt5,
  ghostscript,
}:

python3Packages.buildPythonApplication rec {
  pname = "krop";
  version = "0.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "arminstraub";
    repo = "krop";
    tag = "v${version}";
    hash = "sha256-8mhTUP0oS+AnZXVmywxBTbR1OOg18U0RQ1H9lyjaiVI=";
  };

  nativeBuildInputs = [ libsForQt5.wrapQtAppsHook ];

  buildInputs = [
    libsForQt5.poppler
    libsForQt5.qtwayland
  ];

  dependencies = with python3Packages; [
    pyqt5
    pypdf2
    poppler-qt5
    ghostscript
  ];

  makeWrapperArgs = [ "\${qtWrapperArgs[@]}" ];

  # Disable checks because of interference with older Qt versions // xcb
  doCheck = false;

  meta = {
    homepage = "http://arminstraub.com/software/krop";
    description = "Graphical tool to crop the pages of PDF files";
    longDescription = ''
      Krop is a tool that allows you to optimise your PDF files, and remove
      sections of the page you do not want.  A unique feature of krop, at least to my
      knowledge, is its ability to automatically split pages into subpages to fit the
      limited screensize of devices such as eReaders. This is particularly useful, if
      your eReader does not support convenient scrolling. Krop also has a command line
      interface.
    '';
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "krop";
  };
}
