{ lib
, stdenv
, fetchFromGitHub
, fetchFromGitLab
, cargo
, desktop-file-utils
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, wrapGAppsHook4
, cairo
, gdk-pixbuf
, glib
, gtk4
, libadwaita
, pango
, pipewire
, wireplumber
}:

let
  wireplumber_0_4 = wireplumber.overrideAttrs (attrs: rec {
    version = "0.4.17";
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "pipewire";
      repo = "wireplumber";
      rev = version;
      hash = "sha256-vhpQT67+849WV1SFthQdUeFnYe/okudTQJoL3y+wXwI=";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "pwvucontrol";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "saivert";
    repo = "pwvucontrol";
    rev = version;
    hash = "sha256-cWNWdCMk9hF8Nzq2UFBEKSx1zS8JlplMG7B5gv7BaZA=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "wireplumber-0.1.0" = "sha256-r3p4OpmMgiFgjn1Fj4LeMOhx6R2UWollIdJRy/0kiNM=";
    };
  };

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    pango
    pipewire
    wireplumber_0_4
  ];

  meta = with lib; {
    description = "Pipewire Volume Control";
    homepage = "https://github.com/saivert/pwvucontrol";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda Guanran928 ];
    mainProgram = "pwvucontrol";
    platforms = platforms.linux;
  };
}
