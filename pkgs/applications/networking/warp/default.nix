{
  lib,
  stdenv,
  fetchFromGitLab,
  appstream-glib,
  cargo,
  desktop-file-utils,
  itstool,
  meson,
  ninja,
  pkg-config,
  python3,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  glib,
  gtk4,
  libadwaita,
  zbar,
  gst_all_1,
  Security,
  Foundation,
}:

stdenv.mkDerivation rec {
  pname = "warp";
  version = "0.7.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "warp";
    rev = "v${version}";
    hash = "sha256-GRxZ3y1PdJpBDnGCfmOmZgN8n1aaYf9IhyszRwo3MjQ=";
  };

  postPatch = ''
    patchShebangs build-aux
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-v/MhVcQmMYD/n/8wmPCYUy4YpXhL0v4fq8h6cllo/pw=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs =
    [
      glib
      gtk4
      libadwaita
      zbar
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-bad
    ])
    ++ lib.optionals stdenv.isDarwin [
      Security
      Foundation
    ];

  meta = {
    description = "Fast and secure file transfer";
    homepage = "https://apps.gnome.org/Warp/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dotlambda
      foo-dogsquared
    ];
    platforms = lib.platforms.all;
    mainProgram = "warp";
    broken = stdenv.isDarwin;
  };
}
