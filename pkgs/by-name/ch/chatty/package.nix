{
  lib,
  stdenv,
  fetchFromGitLab,
  appstream-glib,
  desktop-file-utils,
  itstool,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  evolution-data-server,
  feedbackd,
  glibmm,
  libsecret,
  gnome-desktop,
  gspell,
  gtk4,
  gtksourceview5,
  gst_all_1,
  libcmatrix,
  libadwaita,
  libphonenumber,
  modemmanager,
  pidgin,
  protobuf,
  sqlite,
  plugins ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chatty";
  version = "0.8.6";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Chatty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iPqV3xluzHPm8TCOOLvczoAPe3LuJuhWEBnQWBUU18U=";
  };

  postPatch = ''
    # https://gitlab.gnome.org/World/Chatty/-/merge_requests/1465
    substituteInPlace src/matrix/chatty-ma-account.c \
      --replace-fail '#include <libsecret/secret.h>' ""
  '';

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
    libcmatrix
    libadwaita
    libphonenumber
    modemmanager
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
    changelog = "https://gitlab.gnome.org/World/Chatty/-/blob/${finalAttrs.src.tag}/NEWS";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
})
