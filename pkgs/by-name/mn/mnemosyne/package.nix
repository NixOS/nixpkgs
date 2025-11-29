{
  python3Packages,
  fetchurl,
  qt6,
}:

python3Packages.buildPythonApplication rec {
  pname = "mnemosyne";
  version = "2.10.1";
  pyproject = true;

  src = fetchurl {
    url = "mirror://sourceforge/project/mnemosyne-proj/mnemosyne/mnemosyne-${version}/Mnemosyne-${version}.tar.gz";
    sha256 = "sha256-zI79iuRXb5S0Y87KfdG+HKc0XVNQOAcBR7Zt/OdaBP4=";
  };

  postPatch = ''
    # fix wrong installation location
    substituteInPlace setup.py \
      --replace-fail "path.join(sys.exec_prefix," "path.join("

    substituteInPlace mnemosyne/libmnemosyne/gui_translators/gettext_gui_translator.py \
      --replace-fail "path.join(sys.exec_prefix," "path.join('$out', "
  '';

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  buildInputs = [ qt6.qtbase ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    cheroot
    googletrans # we should be using google-trans-new instead, but it's currently unpackaged
    gtts
    matplotlib
    pyqt6
    pyqt6-webengine
    argon2-cffi
    webob
  ];

  # No tests/ directory in tarball
  doCheck = false;

  dontWrapQtApps = true;

  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
  ];

  meta = {
    homepage = "https://mnemosyne-proj.org/";
    description = "Spaced-repetition software";
    mainProgram = "mnemosyne";
    longDescription = ''
      The Mnemosyne Project has two aspects:

        * It's a free flash-card tool which optimizes your learning process.
        * It's a research project into the nature of long-term memory.

      We strive to provide a clear, uncluttered piece of software, easy to use
      and to understand for newbies, but still infinitely customisable through
      plugins and scripts for power users.

      ## Efficient learning

      Mnemosyne uses a sophisticated algorithm to schedule the best time for
      a card to come up for review. Difficult cards that you tend to forget
      quickly will be scheduled more often, while Mnemosyne won't waste your
      time on things you remember well.

      ## Memory research

      If you want, anonymous statistics on your learning process can be
      uploaded to a central server for analysis. This data will be valuable to
      study the behaviour of our memory over a very long time period. The
      results will be used to improve the scheduling algorithms behind the
      software even further.
    '';
  };
}
