{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  rustc,
  wrapGAppsHook4,
  gdk-pixbuf,
  clapper-unwrapped,
  gtk4,
  libadwaita,
  libxml2,
  openssl,
  sqlite,
  webkitgtk_6_0,
  glib-networking,
  librsvg,
  gst_all_1,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "newsflash";
  version = "4.2.1";

  src = fetchFromGitLab {
    owner = "news-flash";
    repo = "news_flash_gtk";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-me9/2sA1Thne10+JrSMvicDRxXuevCnM8Tb+kwXzNDI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-cgu1zP85UCb/6gYNcj/khc6u1kSwX0UZ2oIjM2UUBOA=";
  };

  postPatch = ''
    patchShebangs build-aux/cargo.sh
    meson rewrite kwargs set project / version '${finalAttrs.version}'
    substituteInPlace src/meson.build --replace-fail \
      "'src' / rust_target / 'news_flash_gtk'" \
      "'src' / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / 'news_flash_gtk'"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    blueprint-compiler
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    wrapGAppsHook4

    # Provides setup hook to fix "Unrecognized image file format"
    gdk-pixbuf
  ];

  buildInputs = [
    clapper-unwrapped
    gtk4
    libadwaita
    libxml2
    openssl
    sqlite
    webkitgtk_6_0

    # TLS support for loading external content in webkitgtk WebView
    glib-networking

    # SVG support for gdk-pixbuf
    librsvg
  ]
  ++ (with gst_all_1; [
    # Audio & video support for webkitgtk WebView
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  # For https://gitlab.com/news-flash/news_flash_gtk/-/blob/v.4.2.1/src/meson.build#L48
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v.(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "Modern feed reader designed for the GNOME desktop";
    homepage = "https://gitlab.com/news-flash/news_flash_gtk";
    changelog = "https://gitlab.com/news-flash/news_flash_gtk/-/raw/${finalAttrs.src.tag}/data/io.gitlab.news_flash.NewsFlash.appdata.xml.in.in#:~:text=%3Crelease%20version=%22${finalAttrs.version}%22,%3C/release%3E";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      kira-bruneau
      stunkymonkey
    ];
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.unix;
    mainProgram = "io.gitlab.news_flash.NewsFlash";
  };
})
