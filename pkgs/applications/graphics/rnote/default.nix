{ lib
, stdenv
, fetchFromGitHub
, alsa-lib
, appstream-glib
, cargo
, cmake
, desktop-file-utils
, dos2unix
, glib
, gstreamer
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
, AudioUnit
}:

stdenv.mkDerivation rec {
  pname = "rnote";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "flxzt";
    repo = "rnote";
    rev = "v${version}";
    hash = "sha256-cIy2+Q6HSLwbT0XXDK88Z0mdu46vWSZNTVl8MphXhw0=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ink-stroke-modeler-rs-0.1.0" = "sha256-WfZwezohm8+ZXiKZlssTX+b/Izk1M4jFwxQejeTfc6M=";
      "librsvg-2.57.0-beta.2" = "sha256-8k5KWhm9PIpdmf2DByTyrqX5mGAa+a7ZDGmVO2ERhTU=";
      "piet-0.6.2" = "sha256-WrQok0T7uVQEp8SvNWlgqwQHfS7q0510bnP1ecr+s1Q=";
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
    glib
    gstreamer
    gtk4
    libadwaita
    libxml2
    poppler
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
  ] ++ lib.optionals stdenv.isDarwin [
    AudioUnit
  ];

  postPatch = ''
    dos2unix build-aux/*.py # FIXME remove once updated to 0.9.0
    chmod +x build-aux/*.py
    patchShebangs build-aux
  '';

  meta = with lib; {
    homepage = "https://github.com/flxzt/rnote";
    changelog = "https://github.com/flxzt/rnote/releases/tag/${src.rev}";
    description = "Simple drawing application to create handwritten notes";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda yrd ];
    platforms = platforms.unix;
  };
}
