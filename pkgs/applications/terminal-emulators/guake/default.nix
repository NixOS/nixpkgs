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
  version = "3.6.3";

  format = "other";

  src = fetchFromGitHub {
    owner = "Guake";
    repo = "guake";
    rev = version;
    sha256 = "13ipnmqcyixpa6qv83m0f91za4kar14s5jpib68b32z65x1h0j3b";
  };

  # Strict deps breaks guake
  # See https://github.com/NixOS/nixpkgs/issues/59930
  # and https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

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
    pbr
    pycairo
    pygobject3
    setuptools
  ];

  PBR_VERSION = version; # pbr needs either .git directory, sdist, or env var

  makeFlags = [
    "prefix=${placeholder "out"}"
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
