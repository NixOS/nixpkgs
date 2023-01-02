{ appstream-glib
, blueprint-compiler
, desktop-file-utils
, fetchFromGitHub
, gettext
, glib
, gtk4
, itstool
, lib
, libadwaita
, meson
, mesonEmulatorHook
, ninja
, pkg-config
, stdenv
, wrapGAppsHook4
}:
stdenv.mkDerivation rec {
  pname = "raider";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "ADBeveridge";
    repo = "raider";
    rev = "v${version}";
    hash = "sha256-fyE0CsQp2UVh+7bAQo+GHEF0k8Gwl9j4qclh04AQiVI=";
  };

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with lib; {
    description = "Securely delete your files";
    homepage = "https://apps.gnome.org/app/com.github.ADBeveridge.Raider";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ benediktbroich ];
    platforms = platforms.unix;
  };
}
