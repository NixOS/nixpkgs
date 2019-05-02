{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, ninja, python3, glib, gsettings-desktop-schemas, gtk3, libgee, json-glib, glib-networking, libsoup, libunity, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "fondo";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "calo001";
    repo = pname;
    rev = version;
    sha256 = "0mh3s2726zf3va6nj7kj2nbmq5q65xrbnsllss3sqf8a838zqfn6";
  };

  nativeBuildInputs = [
    meson
    ninja
    pantheon.vala
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    glib-networking
    gsettings-desktop-schemas
    gtk3
    json-glib
    libgee
    libsoup
    libunity
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Find the most beautiful wallpapers for your desktop";
    homepage = https://github.com/calo001/fondo;
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
