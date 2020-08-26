{ stdenv, fetchFromGitLab, vala, python3, pkgconfig, meson, ninja, gtk3
, json-glib, libsoup, webkitgtk, geocode-glib, nix-update-script
, libappindicator, desktop-file-utils, appstream, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "meteo";
  version = "0.9.8";

  src = fetchFromGitLab {
    owner = "bitseater";
    repo = pname;
    rev = version;
    sha256 = "1ll5fja0dqxcr6hrh2dk4hgw9gf8ms9bcp1ifznd21byxzyhdlr0";
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
    json-glib
    libappindicator
    libsoup
    webkitgtk
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };


  meta = with stdenv.lib; {
    description = "Know the forecast of the next hours & days";
    homepage = "https://gitlab.com/bitseater/meteo";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
