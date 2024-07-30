{ lib
, stdenv
, fetchFromGitHub
, alsa-lib
, appstream
, appstream-glib
, cargo
, cmake
, desktop-file-utils
, dos2unix
, glib
, gst_all_1
, gtk4
, libadwaita
, libxml2
, meson
, ninja
, pkg-config
, poppler
, python3
, rustPlatform
, rustc
, shared-mime-info
, wrapGAppsHook4
, darwin
}:

stdenv.mkDerivation rec {
  pname = "rnote";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "flxzt";
    repo = "rnote";
    rev = "v${version}";
    hash = "sha256-RbuEgmly6Mjmx58zOV+tg6Mv5ghCNy/dE5FXYrEXtdg=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ink-stroke-modeler-rs-0.1.0" = "sha256-B6lT6qSOIHxqBpKTE4nO2+Xs9KF7JLVRUHOkYp8Sl+M=";
      "piet-0.6.2" = "sha256-3juXzuKwoLuxia6MoVwbcBJ3jXBQ9QRNVoxo3yFp2Iw=";
    };
  };

  nativeBuildInputs = [
    appstream-glib # For appstream-util
    cmake
    desktop-file-utils # For update-desktop-database
    dos2unix
    meson
    ninja
    pkg-config
    python3 # For the postinstall script
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
    shared-mime-info # For update-mime-database
    wrapGAppsHook4
  ];

  dontUseCmakeConfigure = true;

  mesonFlags = [
    (lib.mesonBool "cli" true)
  ];

  buildInputs = [
    appstream
    glib
    gst_all_1.gstreamer
    gtk4
    libadwaita
    libxml2
    poppler
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AudioUnit
  ];

  postPatch = ''
    chmod +x build-aux/*.py
    patchShebangs build-aux
  '';

  meta = with lib; {
    homepage = "https://github.com/flxzt/rnote";
    changelog = "https://github.com/flxzt/rnote/releases/tag/${src.rev}";
    description = "Simple drawing application to create handwritten notes";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda gepbird yrd ];
    platforms = platforms.unix;
    # compiler error since 2023-11-17
    broken = stdenv.isDarwin;
  };
}
