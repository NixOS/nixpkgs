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
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "saivert";
    repo = "pwvucontrol";
    rev = version;
    hash = "sha256-soxB8pbbyYe1EXtopq1OjoklEDJrwK6od4nFLDwb8LY=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "wireplumber-0.1.0" = "sha256-+LZ8xKok2AOegW8WvfrfZGXuQB4xHrLNshcTOHab+xQ=";
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
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "pwvucontrol";
    platforms = platforms.linux;
  };
}
