{ stdenv
, fetchFromGitHub
, vala
, meson
, ninja
, pkgconfig
, pantheon
, python3
, gettext
, glib
, gtk3
, hicolor-icon-theme
, libgee
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "appeditor";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "donadigo";
    repo = "appeditor";
    rev = version;
    sha256 = "04x2f4x4dp5ca2y3qllqjgirbyl6383pfl4bi9bkcqlg8b5081rg";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    vala
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    hicolor-icon-theme
    pantheon.granite
    libgee
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Edit the Pantheon desktop application menu";
    homepage = https://github.com/donadigo/appeditor;
    maintainers = with maintainers; [ kjuvi ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
