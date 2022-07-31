{ lib, fetchFromGitHub, fetchFromGitLab, gitUpdater
, meson, ninja, pkg-config, wrapGAppsHook
, desktop-file-utils, gsettings-desktop-schemas, libadwaita, libnotify, webkitgtk
, python3Packages, gettext
, appstream-glib, gdk-pixbuf, glib, gobject-introspection, gspell, gtk4, gtksourceview5, gnome
, steam, xdg-utils, pciutils, cabextract
, freetype, p7zip, gamemode, mangohud, xdpyinfo, imagemagick
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
  # require libadwaita >= 1.2 see https://github.com/bottlesdevs/Bottles/wiki/Packaging
  libadwaita-git = libadwaita.overrideAttrs (oldAttrs: rec {
    version = "1.2.alpha";
    src = fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "GNOME";
      repo = "libadwaita";
      rev = version;
      hash = "sha256-JMxUeIOUPp9k5pImQqWLVkQ2GHaKvopvg6ol9pvA+Bk=";
    };
  });
in
python3Packages.buildPythonApplication rec {
  pname = "bottles";
  version = "2022.7.28-brescia-2";

  src = fetchFromGitHub {
    owner = "bottlesdevs";
    repo = pname;
    rev = version;
    sha256 = "sha256-fg0i0fVbUWieksBv4k4ujLzyHyM6UShwRt7fN/KunJg=";
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
    gtk4
    gtksourceview5
    libadwaita-git
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
    icoextract
    fvs
    pefile
    urllib3
    chardet
    certifi
    idna
    pillow
    orjson
  ] ++ [
    imagemagick
    steam-run
    xdg-utils
    pciutils
    cabextract
    wine
    freetype
    p7zip
    gamemode # programs.gamemode.enable
    mangohud
    xdpyinfo
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
