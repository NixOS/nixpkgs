{ lib
, stdenv
, fetchFromGitLab
, appstream-glib
, desktop-file-utils
, itstool
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, evolution-data-server
, feedbackd
, glibmm
, libsecret
, gnome-desktop
, gspell
, gtk4
, gtksourceview5
, gst_all_1
, json-glib
, libgcrypt
, libadwaita
, libphonenumber
, modemmanager
, olm
, pidgin
, protobuf
, sqlite
, plugins ? [ ]
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chatty";
  version = "0.8.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Chatty";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-1CHreTkw1C3tc6vOCG+7Y/u4R/xTFOnlI4mcxjY/alY=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    evolution-data-server
    feedbackd
    glibmm
    libsecret
    gnome-desktop
    gspell
    gtk4
    gtksourceview5
    gst_all_1.gstreamer
    json-glib
    libgcrypt
    libadwaita
    libphonenumber
    modemmanager
    olm
    pidgin
    protobuf
    sqlite
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PURPLE_PLUGIN_PATH : ${lib.escapeShellArg (pidgin.makePluginPath plugins)}
      ${lib.concatMapStringsSep " " (p: p.wrapArgs or "") plugins}
    )
  '';

  meta = with lib; {
    description = "XMPP and SMS messaging via libpurple and ModemManager";
    mainProgram = "chatty";
    homepage = "https://gitlab.gnome.org/World/Chatty";
    changelog = "https://gitlab.gnome.org/World/Chatty/-/blob/${finalAttrs.src.rev}/NEWS";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
})
