{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cacert,
  cargo,
  cmake,
  glib,
  glib-networking,
  gettext,
  gst_all_1,
  gtk4,
  libadwaita,
  ninja,
  pkg-config,
  rustc,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rufin";
  version = "0.15.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "screwys";
    repo = "Rufin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XBLQjf1YpoOd4SsMVI9Th4Amfgaqb1wbjXtxwY7dC0Q=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-jRYkBcCA0P2wCsCmpg9vCJF0qy/YTa9XW1WJtPtOGhw=";
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
    glib
    glib-networking
    gtk4
    libadwaita
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ]);

  doCheck = false;

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  cmakeFlags = [
    (lib.cmakeFeature "RUFIN_BUILD_IDENTITY" "stable")
    (lib.cmakeBool "RUFIN_CARGO_FROZEN" true)
  ];

  postInstall = ''
    substituteInPlace "$out/share/applications/io.github.screwys.Rufin.desktop" \
      --replace-fail "Exec=rufin" "Exec=$out/bin/rufin"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set-default RUFIN_LOCALEDIR "$out/share/locale"
      --set-default SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt"
    )
  '';

  meta = {
    description = "Native GTK4/libadwaita music client for Jellyfin, Subsonic, Navidrome and local libraries written in Rust";
    homepage = "https://github.com/screwys/Rufin";
    changelog = "https://github.com/screwys/Rufin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ screwys ];
    mainProgram = "rufin";
    platforms = lib.platforms.linux;
  };
})
