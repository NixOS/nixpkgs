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
  pname = "nix-software";
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SPTApyo";
    repo = "nix-software";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x5g8O1zgqBleaKTYs8HuDmq6BbFKHkB5wZDOhYVHOKs=";
  };

  cargoHash = "sha256-4uHYWKwBQagr4koRZv48Bzqh4b2f0oYDpTYvqI2Eg1M=";

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

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "nix-software-cli --version";
      };
      module = nixosTests.nix-software;
    };
  };

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
