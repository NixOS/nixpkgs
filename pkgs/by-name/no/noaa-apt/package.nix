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

rustPlatform.buildRustPackage rec {
  pname = "noaa-apt";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "martinber";
    repo = "noaa-apt";
    rev = "v${version}";
    sha256 = "sha256-EGbUI9CPgP6Tff2kvIU7pfSlIvyF0yRLo/VlttUn3Rc=";
  };

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

  cargoHash = "sha256-fCFIIRSvVSaO7XA/cSZi03g+w7Mg+MpEo6vmGviHtoU=";

  cargoPatches = [
    # time 0.3.30 specified in upstream Cargo.lock is incompatible with newer Rust versions
    ./cargo-update-time.patch
  ];

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
      trepetti
      tmarkus
    ];
    platforms = lib.platforms.all;
    changelog = "https://github.com/martinber/noaa-apt/releases/tag/v${version}";
    mainProgram = "noaa-apt";
  };
}
