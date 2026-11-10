{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  openssl,
  pango,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "noaa-apt";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "martinber";
    repo = "noaa-apt";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-EGbUI9CPgP6Tff2kvIU7pfSlIvyF0yRLo/VlttUn3Rc=";
  };

  cargoPatches = [
    # https://github.com/martinber/noaa-apt/pull/66
    ./fix-shapefile-build-failure.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    openssl
    pango
  ];

  cargoHash = "sha256-y0XBgc7bWZ0lMMlFe7U0UkeIQ//3StwFJNWInNNaAUQ=";

  preBuild = ''
    # Used by macro pointing to resource location at compile time.
    export NOAA_APT_RES_DIR=$out/share/noaa-apt
  '';

  postInstall = ''
    # Resources.
    mkdir -p $out/share/noaa-apt
    cp -R $src/res/* $out/share/noaa-apt/

    # Desktop icon.
    install -Dm644 -t $out/share/applications $src/debian/ar.com.mbernardi.noaa-apt.desktop
    install -Dm644 -t $out/share/icons/hicolor/48x48/apps $src/debian/ar.com.mbernardi.noaa-apt.png
    install -Dm644 -t $out/share/icons/hicolor/scalable/apps $src/debian/ar.com.mbernardi.noaa-apt.svg
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "NOAA APT image decoder";
    homepage = "https://noaa-apt.mbernardi.com.ar/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      tmarkus
    ];
    platforms = lib.platforms.all;
    changelog = "https://github.com/martinber/noaa-apt/releases/tag/v${finalAttrs.version}";
    mainProgram = "noaa-apt";
  };
})
