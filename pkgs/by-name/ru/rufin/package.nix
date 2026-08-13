{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cacert,
  glib,
  gettext,
  gst_all_1,
  gtk4,
  libadwaita,
  pkg-config,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rufin";
  version = "0.13.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "screwys";
    repo = "Rufin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xNeANA+qiegxojC3YO0JOMk92Qv+FAFe0/YO4He/I80=";
  };

  cargoHash = "sha256-UitZfrsvfHkiQUTAq8srstBGRbcuKBn5OJ+WUq1jdqI=";

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
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

  cargoBuildFlags = [
    "-p"
    "rufin"
  ];

  doCheck = false;

  installPhase = ''
    runHook preInstall

    rufin_binary="$(find target -type f -path "*/$cargoBuildType/rufin" -perm -0100 -print -quit)"
    cargo run -p xtask --target ${stdenv.buildPlatform.rust.rustcTarget} -- install linux \
      --binary "$rufin_binary" \
      --destdir "$out" \
      --prefix /
    substituteInPlace "$out/share/applications/io.github.screwys.Rufin.desktop" \
      --replace-fail "Exec=rufin" "Exec=$out/bin/rufin"

    runHook postInstall
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
