{
  lib,
  stdenv,
  fetchFromGitHub,
  vala,
  ninja,
  wrapGAppsHook4,
  pkg-config,
  gettext,
  gobject-introspection,
  glib,
  gdk-pixbuf,
  gtk4,
  glib-networking,
  libadwaita,
  libcanberra,
  libnotify,
  libsoup_3,
  libgee,
  libomemo-c,
  libgcrypt,
  meson,
  sqlite,
  gpgme,
  qrencode,
  icu,
  srtp,
  libnice,
  gnutls,
  gst_all_1,
  webrtc-audio-processing,
}:

# Upstream is very deliberate about which features are enabled per default or are automatically enabled.
# Everything that is disabled per default has to been seen experimental and should not be enabled without strong reasoning.
# see https://github.com/NixOS/nixpkgs/issues/469614#issuecomment-3649662176

stdenv.mkDerivation (finalAttrs: {
  pname = "dino";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "dino";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TgXPJP+Xm8LrO2d8yMu6aCCypuBRKNtYuZAb0dYfhng=";
  };

  postPatch = ''
    echo ${finalAttrs.version} > VERSION
  '';

  nativeBuildInputs = [
    vala
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gettext
    gobject-introspection
  ];

  buildInputs = [
    qrencode
    glib
    glib-networking # required for TLS support
    libadwaita
    libgee
    sqlite
    gdk-pixbuf
    gtk4
    libnotify
    gpgme
    libgcrypt
    libsoup_3
    icu
    libcanberra
    libomemo-c
    srtp
    libnice
    gnutls
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    webrtc-audio-processing
  ];

  doCheck = true;

  # Undefined symbols for architecture arm64: "_gpg_strerror"
  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-lgpg-error";

  # Dino looks for plugins with a .so filename extension, even on macOS where
  # .dylib is appropriate, and despite the fact that it builds said plugins with
  # that as their filename extension
  #
  # Therefore, on macOS rename all of the plugins to use correct names that Dino
  # will load
  #
  # See https://github.com/dino/dino/wiki/macOS
  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    cd "$out/lib/dino/plugins/"
    for f in *.dylib; do
      mv "$f" "$(basename "$f" .dylib).so"
    done
  '';

  meta = {
    description = "Modern Jabber/XMPP Client using GTK/Vala";
    mainProgram = "dino";
    homepage = "https://github.com/dino/dino";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ qyliss ];
  };
})
