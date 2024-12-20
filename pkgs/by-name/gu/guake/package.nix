{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python311,
  python311Packages,
  glibcLocales,
  gobject-introspection,
  wrapGAppsHook3,
  gtk3,
  keybinder3,
  libnotify,
  libutempter,
  vte,
  libwnck,
  dconf,
  nixosTests,
}:

python311Packages.buildPythonApplication rec {
  pname = "guake";
  version = "3.10";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "Guake";
    repo = "guake";
    rev = "refs/tags/${version}";
    hash = "sha256-e6Bf4HDftHBxFPcw9z02CqgZhSIvt6wlLF6dnIh9fEc=";
  };

  patches = [
    # Avoid trying to recompile schema at runtime,
    # the package should be responsible for ensuring it is up to date.
    # Without this, the package will try to run glib-compile-schemas
    # on every update, which is pointless and will crash
    # unless user has it installed.
    ./no-compile-schemas.patch

    # Avoid using pip since it fails on not being able to find setuptools.
    # Note: This is not a long-term solution, setup.py is deprecated.
    (fetchpatch {
      url = "https://github.com/Guake/guake/commit/14abaa0c69cfab64fe3467fbbea211d830042de8.patch";
      hash = "sha256-RjGRFJDTQX2meAaw3UZi/3OxAtIHbRZVpXTbcJk/scY= ";
      revert = true;
    })

    # Revert switch to FHS.
    (fetchpatch {
      url = "https://github.com/Guake/guake/commit/8c7a23ba62ee262c033dfa5b0b18d3df71361ff4.patch";
      hash = "sha256-0asXI08XITkFc73EUenV9qxY/Eak+TzygRRK7GvhQUc=";
      revert = true;
    })
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
    python311Packages.pip
  ];

  buildInputs = [
    glibcLocales
    gtk3
    keybinder3
    libnotify
    libwnck
    python311
    vte
  ];

  makeWrapperArgs = [ "--set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive" ];

  propagatedBuildInputs = with python311Packages; [
    dbus-python
    pycairo
    pygobject3
    setuptools-scm
    pyyaml
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libutempter ]}"
      # For settings migration.
      --prefix PATH : "${lib.makeBinPath [ dconf ]}"
    )
  '';

  passthru.tests.test = nixosTests.terminal-emulators.guake;

  meta = with lib; {
    description = "Drop-down terminal for GNOME";
    homepage = "http://guake-project.org";
    license = licenses.gpl2Plus;
    maintainers = [
      maintainers.msteen
      maintainers.heywoodlh
    ];
    platforms = platforms.linux;
  };
}
