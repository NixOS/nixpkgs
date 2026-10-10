{
  lib,
  rustPlatform,
  fetchFromGitHub,
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
  pname = "nix-software";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "SPTApyo";
    repo = "nix-software";
    tag = "v${finalAttrs.version}";
    hash = "sha256-phdbkOgp2zODwGeUtcjPWOpkPyX6ilofdrMluWt939w=";
  };

  cargoHash = "sha256-h1rVRH5Y2ipbb0CvgQKVSk6huxcaOIGD21LV/gAqLvk=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    gettext
  ];

  env.GETTEXT_SYSTEM = true;

  buildInputs = [
    gtk4
    libadwaita
    glib
    gsettings-desktop-schemas
  ];

  cargoTestFlags = [
    "--package"
    "nix-software-core"
  ];
  nativeCheckInputs = [
    git
    nix
  ];

  postInstall = ''
    install -Dm644 -t $out/share/applications crates/gui/data/io.github.sptapyo.NixSoftware.desktop
    install -Dm644 -t $out/share/metainfo crates/gui/data/io.github.sptapyo.NixSoftware.metainfo.xml
    install -Dm644 -t $out/share/gnome-shell/search-providers \
      crates/gui/data/io.github.sptapyo.NixSoftware.search-provider.ini
    # Lets GNOME Shell start the app to answer searches.
    install -d $out/share/dbus-1/services
    printf '[D-BUS Service]\nName=io.github.sptapyo.NixSoftware\nExec=%s --gapplication-service\n' \
      "$out/bin/nix-software" > $out/share/dbus-1/services/io.github.sptapyo.NixSoftware.service
    install -Dm644 -t $out/share/icons/hicolor/scalable/apps \
      crates/gui/data/icons/hicolor/scalable/apps/io.github.sptapyo.NixSoftware.svg
    mkdir -p $out/share/nix-software/icons
    cp -r crates/gui/data/icons/hicolor $out/share/nix-software/icons/
    for po in po/*.po; do
      lang=$(basename "$po" .po)
      install -d $out/share/locale/$lang/LC_MESSAGES
      msgfmt "$po" -o $out/share/locale/$lang/LC_MESSAGES/nix-software.mo
    done
  '';

  preFixup = ''
    gappsWrapperArgs+=(--set NIX_SOFTWARE_LOCALEDIR "$out/share/locale")
  '';

  meta = {
    description = "Declarative app store for NixOS and Home Manager, built around try first";
    homepage = "https://github.com/SPTApyo/nix-software";
    changelog = "https://github.com/SPTApyo/nix-software/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ SPTApyo ];
    mainProgram = "nix-software";
    platforms = lib.platforms.linux;
  };
})
