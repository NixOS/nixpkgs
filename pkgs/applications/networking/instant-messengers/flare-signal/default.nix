{ lib
, stdenv
, fetchFromGitLab
, cargo
, meson
, ninja
, pkg-config
, protobuf
, libsecret
, libadwaita
, rustPlatform
, rustc
, desktop-file-utils
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "flare";
  version = "0.8.0";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "Schmiddiii";
    repo = pname;
    rev = version;
    hash = "sha256-w4WaWcUsjKiWfNe5StwRcPlcXqWz0427It96L1NsR0U=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "curve25519-dalek-3.2.1" = "sha256-0hFRhn920tLBpo6ZNCl6DYtTMHMXY/EiDvuhOPVjvC0=";
      "libsignal-protocol-0.1.0" = "sha256-IBhmd3WzkICiADO24WLjDJ8pFILGwWNUHLXKpt+Y0IY=";
      "libsignal-service-0.1.0" = "sha256-art5O06X4lhp9PoAd23mi6F1wRWkUcyON7AK8uBDoK8=";
      "presage-0.6.0-dev" = "sha256-DVImXySYL0zlGkwss/5DnQ3skTaBa7l55VWIGCd6kQU=";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils # for update-desktop-database
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    libadwaita
    libsecret
    protobuf
  ];

  meta = {
    changelog = "https://gitlab.com/Schmiddiii/flare/-/blob/${src.rev}/CHANGELOG.md";
    description = "An unofficial Signal GTK client";
    homepage = "https://gitlab.com/Schmiddiii/flare";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda tomfitzhenry ];
    platforms = lib.platforms.linux;
  };
}
