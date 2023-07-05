{ lib
, fetchFromGitHub
, python3
, glibcLocales
, gobject-introspection
, wrapGAppsHook
, gtk3
, keybinder3
, libnotify
, libutempter
, vte
, libwnck
, nixosTests
}:

python3.pkgs.buildPythonApplication rec {
  pname = "guake";
  version = "3.9.0";

  format = "other";

  src = fetchFromGitHub {
    owner = "Guake";
    repo = "guake";
    rev = "refs/tags/${version}";
    sha256 = "sha256-BW13fBH26UqMPMjV8JC4QkpgzyoPfCpAfSkJD68uOZU=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
    python3.pkgs.pip
  ];

  buildInputs = [
    glibcLocales
    gtk3
    keybinder3
    libnotify
    libwnck
    python3
    vte
  ];

  makeWrapperArgs = [ "--set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive" ];

  propagatedBuildInputs = with python3.pkgs; [
    dbus-python
    pycairo
    pygobject3
    setuptools-scm
    pyyaml
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libutempter ]}")
  '';

  passthru.tests.test = nixosTests.terminal-emulators.guake;

  meta = with lib; {
    description = "Drop-down terminal for GNOME";
    homepage = "http://guake-project.org";
    license = licenses.gpl2;
    maintainers = [ maintainers.msteen ];
    platforms = platforms.linux;
  };
}
