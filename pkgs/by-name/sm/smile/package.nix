{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, appstream-glib
, desktop-file-utils
, gettext
, glib
, libwnck
, libadwaita
, wrapGAppsHook4
, pkg-config
, python3Packages
, gobject-introspection
}:

python3Packages.buildPythonApplication rec {
  pname = "smile";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "mijorus";
    repo = pname;
    rev = version;
    hash = "sha256-yHWFG587qNij61Ul0z/Tn7HGN8dBBNQL4e0PvjA06js=";
  };

  format = "other";

  postPatch = ''
    chmod +x ./build-aux/meson/postinstall.py
    patchShebangs ./build-aux/meson/postinstall.py
    substituteInPlace ./build-aux/meson/postinstall.py \
      --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  nativeBuildInputs = [
    gettext
    desktop-file-utils
    appstream-glib
    meson
    ninja
    pkg-config
    glib
    wrapGAppsHook4
  ];

  propagatedNativeBuildInputs = [
    gobject-introspection
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    manimpango
    dbus-python
  ];

  buildInputs = [
    libwnck
    libadwaita
  ];

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://smile.mijorus.it";
    description = "Emoji picker with custom tabs support and localization";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ foo-dogsquared ];
    mainProgram = "smile";
    platforms = platforms.linux;
  };
}
