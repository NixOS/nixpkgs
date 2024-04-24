{ lib
, stdenv
, fetchFromGitLab
, rustPlatform
, nix-update-script

, appstream
, blueprint-compiler
, cargo
, desktop-file-utils
, meson
, ninja
, pkg-config
, rustc
, wrapGAppsHook4

, dav1d
, gst_all_1
, gtk4
, libadwaita
, libwebp
}:

stdenv.mkDerivation rec {
  pname = "identity";
  version = "0.6.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "YaLTeR";
    repo = "identity";
    rev = "v${version}";
    hash = "sha256-AiOaTjYOc7Eo+9kl1H91TKAkCKNUJNWobmBENZlHBhQ=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "gst-plugin-gtk4-0.12.0-alpha.1" = "sha256-JSw9yZ4oy7m6c9pqOT+fnYEbTlneLTtWQf3/Jbek/ps=";
    };
  };

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    dav1d
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    gtk4
    libadwaita
    libwebp
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A program for comparing multiple versions of an image or video";
    mainProgram = "identity";
    homepage = "https://gitlab.gnome.org/YaLTeR/identity";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
