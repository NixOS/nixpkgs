{ stdenv
, fetchFromGitHub
, desktop-file-utils
, gettext
, glib
, gtk3
, hicolor-icon-theme
, libgee
, meson
, ninja
, pantheon
, pkgconfig
, python3
, webkitgtk
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "ephemeral";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = "ephemeral";
    rev = version;
    sha256 = "1bdqi1k1x2aywi2jm610qil2k5xn2kbs2nni55c5pgilq0sd7xnp";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pantheon.vala
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    hicolor-icon-theme
    libgee
    pantheon.granite
    python3
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
