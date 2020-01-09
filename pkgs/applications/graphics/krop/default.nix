{ stdenv, fetchFromGitHub, python3Packages, libsForQt5, ghostscript, qt5}:

python3Packages.buildPythonApplication rec {
  pname = "krop";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "arminstraub";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b1zqpks4vzq7sfhf7r9qrshr77f1ncj18x7d0fa3g29rxa42dcr";
  };

  propagatedBuildInputs = with python3Packages; [
    pyqt5
    pypdf2
    poppler-qt5
    libsForQt5.poppler
    ghostscript
  ];

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];
  makeWrapperArgs = [
   "\${qtWrapperArgs[@]}"
  ];

  # Disable checks because of interference with older Qt versions // xcb
  doCheck = false;

  meta = {
    homepage = http://arminstraub.com/software/krop;
    description = "Graphical tool to crop the pages of PDF files";
    longDescription = ''
    Krop is a tool that allows you to optimise your PDF files, and remove
    sections of the page you do not want.  A unique feature of krop, at least to my
    knowledge, is its ability to automatically split pages into subpages to fit the
    limited screensize of devices such as eReaders. This is particularly useful, if
    your eReader does not support convenient scrolling. Krop also has a command line
    interface.
    '';
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ leenaars ];
    platforms = stdenv.lib.platforms.linux;
  };
}
