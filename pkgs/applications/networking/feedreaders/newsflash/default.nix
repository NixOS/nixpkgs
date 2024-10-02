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
  clapper,
  gtk4,
  libadwaita,
  libxml2,
  openssl,
  sqlite,
  webkitgtk,
  glib-networking,
  librsvg,
  gst_all_1,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "newsflash";
  version = "3.3.5";

  src = fetchFromGitLab {
    owner = "news-flash";
    repo = "news_flash_gtk";
    rev = "refs/tags/v.${finalAttrs.version}";
    hash = "sha256-H2/qKnsByidziUldX5MZBrMyMHfuQ4SN9wXizJUGQ8I=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "article_scraper-2.1.0" = "sha256-0jDXH5kkX34tAWK+3hpmW1LWBsFksVgTnSuQX+XXVEM=";
      "clapper-0.1.0" = "sha256-IFFqfSq2OpzfopQXSYfnJ68HGLY+rvcLqk7NTdDd+28=";
      "news-flash-2.3.0-alpha.0" = "sha256-L7siGYdb8v57nBGYs86smlw971fvurYQJKK/AdTpi6s=";
      "newsblur_api-0.3.0" = "sha256-m2178zdJzeskl3BQpZr6tlxTAADehxz8uYcZzi15nhQ=";
    };
  };

  postPatch = ''
    patchShebangs build-aux/cargo.sh
    meson rewrite kwargs set project / version '${finalAttrs.version}'
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
    rustPlatform.cargoSetupHook
    wrapGAppsHook4

    # Provides setup hook to fix "Unrecognized image file format"
    gdk-pixbuf

  ];

  buildInputs =
    [
      clapper
      gtk4
      libadwaita
      libxml2
      openssl
      sqlite
      webkitgtk

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

  passthru.updateScript = gitUpdater { rev-prefix = "v."; };

  meta = {
    description = "Modern feed reader designed for the GNOME desktop";
    homepage = "https://gitlab.com/news-flash/news_flash_gtk";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      kira-bruneau
      stunkymonkey
    ];
    platforms = lib.platforms.unix;
    mainProgram = "io.gitlab.news_flash.NewsFlash";
  };
})
