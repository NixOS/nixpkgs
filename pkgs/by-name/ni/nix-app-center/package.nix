{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  testers,
  nixosTests,
  pkg-config,
  wrapGAppsHook4,
  gettext,
  git,
  nix,
  gtk4,
  libadwaita,
  glib,
  gsettings-desktop-schemas,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-app-center";
  version = "0.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SPTApyo";
    repo = "nix-app-center";
    tag = "v${finalAttrs.version}";
    hash = "sha256-29/AcZawdG3BeTtcG9Ot6rhZaYOYHxztcb2smvX9lzA=";
  };

  cargoHash = "sha256-or/y2mh+vF/uvB+wT5ytHtWT65MCZIJVlpfcg0EpXS0=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    gettext
  ];

  # The gettext bundled by gettext-sys does not build with recent glibc.
  env.GETTEXT_SYSTEM = "1";

  buildInputs = [
    gtk4
    libadwaita
    glib
    gsettings-desktop-schemas
  ];

  # The GUI tests need a display; the core holds the logic.
  cargoTestFlags = [
    "--package"
    "nix-app-center-core"
  ];
  nativeCheckInputs = [
    git
    nix
  ];

  postInstall = ''
    install -Dm644 -t $out/share/applications crates/gui/data/io.github.sptapyo.NixAppCenter.desktop
    install -Dm644 -t $out/share/metainfo crates/gui/data/io.github.sptapyo.NixAppCenter.metainfo.xml
    install -Dm644 -t $out/share/gnome-shell/search-providers \
      crates/gui/data/io.github.sptapyo.NixAppCenter.search-provider.ini
    # Lets GNOME Shell start the app to answer searches.
    install -d $out/share/dbus-1/services
    printf '[D-BUS Service]\nName=io.github.sptapyo.NixAppCenter\nExec=%s --gapplication-service\n' \
      "$out/bin/nix-app-center" > $out/share/dbus-1/services/io.github.sptapyo.NixAppCenter.service
    install -Dm644 -t $out/share/icons/hicolor/scalable/apps \
      crates/gui/data/icons/hicolor/scalable/apps/io.github.sptapyo.NixAppCenter.svg
    mkdir -p $out/share/nix-app-center/icons
    cp -r crates/gui/data/icons/hicolor $out/share/nix-app-center/icons/
    for po in po/*.po; do
      lang=$(basename "$po" .po)
      install -d $out/share/locale/$lang/LC_MESSAGES
      msgfmt "$po" -o $out/share/locale/$lang/LC_MESSAGES/nix-app-center.mo
    done
  '';

  preFixup = ''
    gappsWrapperArgs+=(--set NIX_APP_CENTER_LOCALEDIR "$out/share/locale")
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "nix-app-center-cli --version";
      };
      module = nixosTests.nix-app-center;
    };
  };

  meta = {
    description = "Declarative app store for NixOS and Home Manager, built around try first";
    homepage = "https://github.com/SPTApyo/nix-app-center";
    changelog = "https://github.com/SPTApyo/nix-app-center/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ SPTApyo ];
    mainProgram = "nix-app-center";
    platforms = lib.platforms.linux;
  };
})
