{ lib, fetchFromGitHub
, meson, ninja, pkg-config, wrapGAppsHook
, desktop-file-utils, gsettings-desktop-schemas, libnotify, libhandy
, python3Packages, gettext
, appstream-glib, gdk-pixbuf, glib, gobject-introspection, gspell, gtk3
, steam-run, xdg-utils, pciutils, cabextract, wineWowPackages, webkitgtk, p7zip
}:

python3Packages.buildPythonApplication rec {
  pname = "bottles";
  version = "2021.12.14-treviso-4";

  src = fetchFromGitHub {
    owner = "bottlesdevs";
    repo = pname;
    rev = version;
    hash = "sha256-Lbqw/M37PUmf2af8B+G4IySifoTfBwMXw9UmeymWiNM=";
  };

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
    gettext
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gobject-introspection
    gsettings-desktop-schemas
    gspell
    gtk3
    libhandy
    libnotify
  ];

  propagatedBuildInputs = with python3Packages; [
    pyyaml
    requests
    pycairo
    pygobject3
    lxml
    dbus-python
    gst-python
    liblarch
    patool
    markdown
  ] ++ [
    steam-run
    xdg-utils
    pciutils
    cabextract
    wineWowPackages.minimal
    webkitgtk
    p7zip
  ];

  format = "other";
  strictDeps = false; # broken with gobject-introspection setup hook, see https://github.com/NixOS/nixpkgs/issues/56943
  dontWrapGApps = true; # prevent double wrapping

  preConfigure = ''
    substituteInPlace build-aux/meson/postinstall.py \
      --replace "'update-desktop-database'" "'${desktop-file-utils}/bin/update-desktop-database'"
    substituteInPlace src/backend/runner.py \
      --replace "{runner} {command}" "${steam-run}/bin/steam-run {runner} {command}"
    substituteInPlace src/backend/manager_utils.py \
      --replace "{runner}" " ${steam-run}/bin/steam-run {runner}"
    substituteInPlace src/backend/manager.py \
      --replace "{runner}" " ${steam-run}/bin/steam-run {runner}" \
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "An easy-to-use wineprefix manager";
    homepage = "https://usebottles.com/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ bloomvdomino shamilton ];
    platforms = platforms.linux;
  };
}
