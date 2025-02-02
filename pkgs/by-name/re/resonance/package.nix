{
  lib,
  cargo,
  dbus,
  desktop-file-utils,
  fetchFromGitHub,
  glib,
  gst_all_1,
  gtk4,
  libadwaita,
  libxml2,
  meson,
  ninja,
  nix-update-script,
  openssl,
  pkg-config,
  python3,
  python3Packages,
  rustPlatform,
  rustc,
  sqlite,
  stdenv,
  wrapGAppsHook4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "resonance";
  version = "0-unstable-2023-06-06";

  src = fetchFromGitHub {
    owner = "nate-xyz";
    repo = "resonance";
    rev = "97826093e22418c0efdb4e61cc75d981bb82c120";
    hash = "sha256-DgNUjb8+2WTw91OGgFf97YL6lnODtkftYAP/c05RUPI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    src = finalAttrs.src;
    hash = "sha256-/v3OokClOk95GOzidBHRkUG7kjHQm35yPeC1n3PzcyM=";
  };

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs =
    [
      dbus
      glib
      gtk4
      libadwaita
      libxml2
      openssl
      sqlite
    ]
    ++ (with gst_all_1; [
      gst-libav
      gst-plugins-bad
      gst-plugins-base
      gst-plugins-good
      gst-plugins-ugly
      gstreamer
    ]);

  preFixup = ''
    gappsWrapperArgs+=(--prefix PYTHONPATH : ${
      python3.pkgs.makePythonPath (
        with python3Packages;
        [
          tqdm
          mutagen
          loguru
        ]
      )
    })
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Intuitive GTK4/LibAdwaita music player";
    homepage = "https://github.com/nate-xyz/resonance";
    license = licenses.gpl3Plus;
    mainProgram = "resonance";
    maintainers = with maintainers; [ Guanran928 ];
    platforms = platforms.linux;
  };
})
