{
  lib,
  stdenv,
  fetchgit,

  meson,
  pkg-config,
  ninja,

  gnunet,
  libgnunetchat,
  libhandy,
  libnotify,
  qrencode,
  gst_all_1,
  pipewire,
  libportal-gtk3,
  gtk3,
  gtk4,
  desktop-file-utils,
  libsodium,
  libgcrypt,
  libunistring,

  gnome-characters,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnunet-messenger-gtk";
  version = "0.10.2";

  src = fetchgit {
    url = "https://git.gnunet.org/messenger-gtk.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EhmWamlFfyMepp9W+6nvzrxkRHF9BObSomkwS/Qf5Ro=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    pkg-config
    ninja

    gtk3
    gtk4
    desktop-file-utils
  ];

  buildInputs = [
    gnunet
    libgnunetchat
    libhandy
    libnotify
    qrencode
    pipewire
    libportal-gtk3
    gtk3
    gtk4
    libsodium
    libgcrypt
    libunistring.dev

    gnome-characters
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base.dev
  ]);

  meta = {
    description = "A GTK based GUI for the Messenger service of GNUnet";
    homepage = "https://git.gnunet.org/messenger-gtk.git/about/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    teams = with lib.teams; [ ngi ];
    maintainers = [ lib.maintainers.hustlerone ];
    mainProgram = "messenger-gtk";
  };
})
