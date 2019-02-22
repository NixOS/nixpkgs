{ stdenv, fetchFromGitLab, vala, python3, pkgconfig, meson, ninja, gtk3, geocode-glib, json-glib, libsoup, webkitgtk, libappindicator, desktop-file-utils, hicolor-icon-theme, appstream, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "meteo";
  version = "0.9.6";

  src = fetchFromGitLab {
    owner = "bitseater";
    repo = pname;
    rev = version;
    sha256 = "1786s5637hc3dnnkf5vr2ngfiq73dyvx8187gx7qkh7cr8xrl50w";
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    geocode-glib
    gtk3
    hicolor-icon-theme
    json-glib
    libappindicator
    libsoup
    webkitgtk
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Know the forecast of the next hours & days";
    homepage    = https://gitlab.com/bitseater/meteo;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms   = platforms.linux;
  };
}
