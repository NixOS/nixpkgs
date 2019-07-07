{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkgconfig
, gtk3
, python3
, pantheon
, gnome3
, libxml2
, gettext
, gobject-introspection
, appstream-glib
, desktop-file-utils
, magic-wormhole
, wrapGAppsHook }:

let
  pname = "Transporter";
  version = "1.3.3";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "bleakgrey";
    repo = pname;
    rev = version;
    sha256 = "19zb2yqmyyhk5vgh6p278b76shlq0r8ykk1ks8zzr187nr5lf5k1";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    pantheon.vala
    gettext
    gobject-introspection # For setup hook
    libxml2
    meson
    ninja
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    pantheon.elementary-icon-theme
    gnome3.libgee
    pantheon.granite
    gtk3
    magic-wormhole
  ];

  prePatch = ''
  # The paths were hardcoded
  substituteInPlace ./src/WormholeInterface.vala \
    --replace /bin/wormhole ${magic-wormhole}/bin/wormhole
  '';

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Simple magic-wormhole client";
    homepage    = https://github.com/bleakgrey/Transporter;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
