{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkgconfig
, granite
, vala_0_40
, python3
, gnome3
, libxml2
, gettext
, gobjectIntrospection
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
    gettext
    gobjectIntrospection # For setup hook
    libxml2
    meson
    ninja
    pkgconfig
    vala_0_40
    python3
    wrapGAppsHook
  ];

  buildInputs = with gnome3; [
    defaultIconTheme # If I omit this there's no icons in KDE
    glib
    granite
    gsettings-desktop-schemas
    gtk3
    libgee
    magic-wormhole
  ];

  prePatch = ''
  # The paths were hardcoded
  substituteInPlace ./src/WormholeInterface.vala \
    --replace /bin/wormhole ${magic-wormhole}/bin/wormhole
  '';

  postPatch = ''
    chmod +x ./meson/post_install.py
    patchShebangs ./meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Simple magic-wormhole client";
    homepage    = https://github.com/bleakgrey/Transporter;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
