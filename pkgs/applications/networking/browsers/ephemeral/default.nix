{ stdenv
, fetchFromGitHub
, desktop-file-utils
, gettext
, glib
, gtk3
, hicolor-icon-theme
, libgee
, libdazzle
, meson
, ninja
, pantheon
, pkgconfig
, python3
, webkitgtk
, wrapGAppsHook
, glib-networking
}:

stdenv.mkDerivation rec {
  pname = "ephemeral";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = "ephemeral";
    rev = version;
    sha256 = "01mj5gksz2qcwhp28zyk8qswmrw93db1g7mw3mg4klz99vzcry74";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
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
    gtk3
    hicolor-icon-theme
    libdazzle
    libgee
    pantheon.granite
    webkitgtk
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "The always-incognito web browser";
    homepage = https://github.com/cassidyjames/ephemeral;
    maintainers = with maintainers; [ kjuvi ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
