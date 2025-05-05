{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  sassc,
  vala,
  wrapGAppsHook4,
  appstream,
  dbus,
  flatpak,
  glib,
  granite7,
  gtk4,
  json-glib,
  libadwaita,
  libgee,
  libportal-gtk4,
  libsoup_3,
  libxml2,
  polkit,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "appcenter";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    hash = "sha256-jVMXSy83z4zaG1YtCPRGvj1yl6wa5MJYtNp4XIsIY1k=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    sassc
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    appstream
    dbus
    flatpak
    glib
    granite7
    gtk4
    json-glib
    libadwaita
    libgee
    libportal-gtk4
    libsoup_3
    libxml2
    polkit
  ];

  mesonFlags = [
    "-Dpayments=false"
    "-Dcurated=false"
  ];

  postPatch = ''
    # Since we do not build libxml2 with legacy support,
    # we cannot use compressed appstream metadata.
    # https://gitlab.gnome.org/GNOME/libxml2/-/commit/f7f14537727bf6845d0eea08cd1fdc30accc2a53
    substituteInPlace src/Core/FlatpakBackend.vala \
      --replace-fail ".xml.gz" ".xml"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/elementary/appcenter";
    description = "Open, pay-what-you-want app store for indie developers, designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
    mainProgram = "io.elementary.appcenter";
  };
}
