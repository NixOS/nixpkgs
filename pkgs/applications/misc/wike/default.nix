{ lib
, fetchFromGitHub
, python3
, meson
, ninja
, pkg-config
, appstream-glib
, desktop-file-utils
, gobject-introspection
, wrapGAppsHook4
, glib
, gtk4
, librsvg
, libadwaita
, glib-networking
, webkitgtk_6_0
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wike";
  version = "2.0.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "hugolabe";
    repo = "Wike";
    rev = version;
    hash = "sha256-R8Zg/2tr9MrmtTdbvqD+Ra8+MEBJdgMqC3ptx1VgkeA=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    appstream-glib
    desktop-file-utils
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    librsvg
    libadwaita
    glib-networking
    webkitgtk_6_0
  ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
    pygobject3
  ];

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
    substituteInPlace build-aux/meson/postinstall.py \
      --replace gtk-update-icon-cache gtk4-update-icon-cache
  '';

  # prevent double wrapping
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Wikipedia Reader for the GNOME Desktop";
    homepage = "https://github.com/hugolabe/Wike";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ samalws ];
  };
}
