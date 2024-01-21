{ stdenv
, lib
, fetchFromGitLab
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, libadwaita
, gettext
, glib
, gobject-introspection
, desktop-file-utils
, appstream
, appstream-glib
, gtk4
, librsvg
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "eartag";
  version = "0.5.1";
  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = version;
    hash = "sha256-tHBEz4sZsWOxDkdUd/3zMta8vOhuzv4G01dtjKBX/D0=";
  };

  postPatch = ''
    chmod +x ./build-aux/meson/postinstall.py
    patchShebangs ./build-aux/meson/postinstall.py
    substituteInPlace ./build-aux/meson/postinstall.py \
      --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  nativeBuildInputs = [
    meson
    ninja
    glib
    desktop-file-utils
    appstream
    appstream-glib
    pkg-config
    gettext
    gobject-introspection
    wrapGAppsHook4
  ] ++ lib.optional stdenv.isDarwin gtk4; # for gtk4-update-icon-cache

  buildInputs = [
    librsvg
    libadwaita
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    eyed3
    pillow
    mutagen
    pytaglib
    python-magic
    pyacoustid
  ];

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/eartag";
    description = "Simple music tag editor";
    # This seems to be using ICU license but we're flagging it to MIT license
    # since ICU license is a modified version of MIT and to prevent it from
    # being incorrectly identified as unfree software.
    license = licenses.mit;
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
