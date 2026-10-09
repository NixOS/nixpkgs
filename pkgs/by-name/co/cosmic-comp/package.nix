{
  lib,
  stdenv,
  rustPlatform,
  just,
  fetchFromGitHub,
  libcosmicAppHook,
  pkg-config,
  libdisplay-info_0_3,
  libgbm,
  libinput,
  pixman,
  seatd,
  udev,
  systemd,
  xrdb,
  nix-update-script,
  nixosTests,

  useSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  withXWayland ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-comp";
  version = "1.10.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-comp";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-HkgP/1tVXDMpL47SOZibN1QkDVTRkjrhYmdFcbOc4JY=";
  };

  cargoHash = "sha256-WTpJuj3Xz9hHLj+kuhys0Fr8FmosAuXpbtNSK3Y5twU=";

  # Only default feature is systemd
  buildNoDefaultFeatures = !useSystemd;

  separateDebugInfo = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    just
    libcosmicAppHook
    pkg-config
  ];

  buildInputs = [
    libdisplay-info_0_3
    libgbm
    libinput
    pixman
    seatd
    udev
  ]
  ++ lib.optional useSystemd systemd;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  # With Xwayland, cosmic-comp calls out to `xrdb -merge` to set
  # `Xcursor.size` and `Xcursor.theme` for X11 clients (src/xwayland.rs,
  # upstream pop-os/cosmic-comp#1976). Without it on PATH it logs
  # "`xrdb` not found, cannot update Xresources." and X11 clients fall back
  # to libXcursor's screen-derived default cursor size.
  preFixup = lib.optionalString withXWayland ''
    libcosmicAppWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ xrdb ]})
  '';

  passthru = {
    tests = {
      inherit (nixosTests)
        cosmic
        cosmic-autologin
        cosmic-noxwayland
        cosmic-autologin-noxwayland
        ;
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-comp";
    description = "Compositor for the COSMIC Desktop Environment";
    mainProgram = "cosmic-comp";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
  };
})
