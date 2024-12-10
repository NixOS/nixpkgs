{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch2,
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

  patches = [
    # https://gitlab.gnome.org/World/warp/-/merge_requests/74
    (fetchpatch2 {
      name = "rust-1.80-compat.patch";
      url = "https://gitlab.gnome.org/World/warp/-/commit/38747cc2dde79089df53fd8451ea2db13f9f3714.patch";
      hash = "sha256-9P5LwCHaC6J5WR2OnjCaNE+4de/Jv6XGXS7bOfYrM7w=";
    })
  ];

  postPatch = ''
    patchShebangs build-aux
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}";
    hash = "sha256-xF9AzcO2uawHu7XZay7Wwr2r+OVLbXhfSynnBYbVkZM=";
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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
    broken = stdenv.hostPlatform.isDarwin;
  };
}
