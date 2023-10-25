{ lib
, stdenv
, fetchFromGitLab
, cargo
, meson
, ninja
, pkg-config
, gst_all_1
, protobuf
, libsecret
, libadwaita
, rustPlatform
, rustc
, appstream-glib
, blueprint-compiler
, desktop-file-utils
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "flare";
  version = "0.9.0";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "Schmiddiii";
    repo = pname;
    rev = version;
    hash = "sha256-6p9uuK71fJvJs0U14jJEVb2mfpZWrCZZFE3eoZe9eVo=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "curve25519-dalek-3.2.1" = "sha256-0hFRhn920tLBpo6ZNCl6DYtTMHMXY/EiDvuhOPVjvC0=";
      "libsignal-protocol-0.1.0" = "sha256-IBhmd3WzkICiADO24WLjDJ8pFILGwWNUHLXKpt+Y0IY=";
      "libsignal-service-0.1.0" = "sha256-WSRqBNq9jbe6PSeExfmehNZwjlB70GLlHkrDlw59O5c=";
      "presage-0.6.0-dev" = "sha256-oNDfFLir3XL2UOGrWR/IFO7XTeJKX+vjdrd3qbIomtw=";
    };
  };

  nativeBuildInputs = [
    appstream-glib # for appstream-util
    blueprint-compiler
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

    # To reproduce audio messages
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  meta = {
    changelog = "https://gitlab.com/Schmiddiii/flare/-/blob/${src.rev}/CHANGELOG.md";
    description = "An unofficial Signal GTK client";
    homepage = "https://gitlab.com/Schmiddiii/flare";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
  };
}
