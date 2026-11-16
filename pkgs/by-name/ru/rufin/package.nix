{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  aws-lc,
  cacert,
  cargo,
  cmake,
  glib,
  glib-networking,
  gettext,
  gstreamer,
  gst-plugins-ugly,
  gst-plugins-good,
  gst-plugins-base,
  gst-plugins-bad,
  gst-libav,
  gtk4,
  libadwaita,
  ninja,
  pkg-config,
  rustc,
  sqlite,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rufin";
  version = "0.19.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rufin-app";
    repo = "rufin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D48uJ9u9uVpHfYHv4TNIqRwRrdUQYJL0dJcbWURZnPo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-+TGh4/0r+BPw9LJpB/qOJekv2j7jkYjbjM9MYw9KpW4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cargo
    cmake
    gettext
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    aws-lc
    glib
    glib-networking
    gtk4
    libadwaita
    sqlite
  ]
  ++ [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ];

  doCheck = false;

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  cmakeFlags = [
    (lib.cmakeFeature "RUFIN_BUILD_IDENTITY" "stable")
    (lib.cmakeBool "RUFIN_CARGO_FROZEN" true)
  ];

  postInstall = ''
    substituteInPlace "$out/share/applications/app.rufin.rufin.desktop" \
      --replace-fail "Exec=rufin" "Exec=$out/bin/rufin"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set-default RUFIN_LOCALEDIR "$out/share/locale"
      --set-default SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt"
    )
  '';

  meta = {
    description = "Native music player for Jellyfin, Navidrome/OpenSubsonic, Plex, and Emby servers;  local folders,  WebDAV including a direct Nextcloud browser login path, Samba and NAS shares";
    homepage = "https://github.com/rufin-app/rufin";
    changelog = "https://github.com/rufin-app/rufin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      screwys
      Superredstone
    ];
    mainProgram = "rufin";
    platforms = lib.platforms.linux;
  };
})
