{ lib, fetchFromGitHub, gitUpdater
, meson, ninja, pkg-config, wrapGAppsHook
, desktop-file-utils, gsettings-desktop-schemas, libnotify, libhandy, webkitgtk
, python3Packages, gettext
, appstream-glib, gdk-pixbuf, glib, gobject-introspection, gspell, gtk3, gtksourceview4, gnome
, steam, xdg-utils, pciutils, cabextract
, freetype, p7zip, gamemode, mangohud
, wine
, bottlesExtraLibraries ? pkgs: [ ] # extra packages to add to steam.run multiPkgs
, bottlesExtraPkgs ? pkgs: [ ] # extra packages to add to steam.run targetPkgs
}:

let
  steam-run = (steam.override {
    # required by wine runner `caffe`
    extraLibraries = pkgs: with pkgs; [ libunwind libusb1 gnutls ]
      ++ bottlesExtraLibraries pkgs;
    extraPkgs = pkgs: [ ]
      ++ bottlesExtraPkgs pkgs;
  }).run;
in
python3Packages.buildPythonApplication rec {
  pname = "bottles";
  version = "2022.5.28-trento-3";

  src = fetchFromGitHub {
    owner = "bottlesdevs";
    repo = pname;
    rev = version;
    sha256 = "sha256-KIDLRqDLFTsVAczRpTchnUtKJfVHqbYzf8MhIR5UdYY=";
  };

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py

    substituteInPlace src/backend/wine/winecommand.py \
      --replace \
        'self.__get_runner()' \
        '(lambda r: (f"${steam-run}/bin/steam-run {r}", r)[r == "wine" or r == "wine64"])(self.__get_runner())'
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
    gtksourceview4
    libhandy
    libnotify
    webkitgtk
    gnome.adwaita-icon-theme
  ];

  propagatedBuildInputs = with python3Packages; [
    pyyaml
    pytoml
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
    wine
    freetype
    p7zip
    gamemode # programs.gamemode.enable
    mangohud
  ];

  format = "other";
  strictDeps = false; # broken with gobject-introspection setup hook, see https://github.com/NixOS/nixpkgs/issues/56943
  dontWrapGApps = true; # prevent double wrapping

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.updateScript = gitUpdater {
    inherit pname version;
  };

  meta = with lib; {
    description = "An easy-to-use wineprefix manager";
    homepage = "https://usebottles.com/";
    downloadPage = "https://github.com/bottlesdevs/Bottles/releases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ psydvl shamilton ];
    platforms = platforms.linux;
  };
}
