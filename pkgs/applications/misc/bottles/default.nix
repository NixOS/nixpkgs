{ lib, fetchFromGitHub
, meson, ninja, pkg-config, wrapGAppsHook
, desktop-file-utils, gsettings-desktop-schemas, libnotify, libhandy
, python3Packages, gettext
, appstream-glib, gdk-pixbuf, glib, gobject-introspection, gspell, gtk3
, steam-run, xdg-utils, pciutils, cabextract, wineWowPackages
}:

python3Packages.buildPythonApplication rec {
  pname = "bottles";
  version = "2021.7.28-treviso-2";

  src = fetchFromGitHub {
    owner = "bottlesdevs";
    repo = pname;
    rev = version;
    sha256 = "0kvwcajm9izvkwfg7ir7bks39bpc665idwa8mc8d536ajyjriysn";
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
  ] ++ [
    steam-run
    xdg-utils
    pciutils
    cabextract
    wineWowPackages.minimal
  ];

  format = "other";
  strictDeps = false; # broken with gobject-introspection setup hook, see https://github.com/NixOS/nixpkgs/issues/56943
  dontWrapGApps = true; # prevent double wrapping

  preConfigure = ''
    substituteInPlace build-aux/meson/postinstall.py \
      --replace "'update-desktop-database'" "'${desktop-file-utils}/bin/update-desktop-database'"
    substituteInPlace src/runner.py \
      --replace " {runner}" " ${steam-run}/bin/steam-run {runner}" \
      --replace " {dxvk_setup}" " ${steam-run}/bin/steam-run {dxvk_setup}"
      substituteInPlace src/runner_utilities.py \
        --replace " {runner}" " ${steam-run}/bin/steam-run {runner}" \
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
