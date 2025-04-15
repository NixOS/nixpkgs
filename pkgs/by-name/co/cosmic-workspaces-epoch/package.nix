{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cosmic-wallpapers,
  libcosmicAppHook,
  pkg-config,
  libinput,
  libgbm,
  udev,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-workspaces-epoch";
  version = "1.0.0-alpha.6";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-workspaces-epoch";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-3jivE0EaSddPxMYn9DDaYUMafPf60XeCwVeQegbt++c=";
  };

  postPatch = ''
    # While the `kate-hazen-COSMIC-desktop-wallpaper.png` image is present
    # in the `pop-wallpapers` package, we're using the Orion Nebula image
    # from NASA available in the `cosmic-wallpapers` package. Mainly because
    # the previous image was used in the GNOME shell extension and the
    # Orion Nebula image is widely used in the Rust-based COSMIC DE's
    # marketing materials. Another reason to use the Orion Nebula image
    # is that it's actually the default wallpaper as configured by the
    # `cosmic-bg` package's configuration in upstream [1] [2].
    #
    # [1]: https://github.com/pop-os/cosmic-bg/blob/epoch-1.0.0-alpha.6/config/src/lib.rs#L142
    # [2]: https://github.com/pop-os/cosmic-bg/blob/epoch-1.0.0-alpha.6/data/v1/all#L3
    substituteInPlace src/view/mod.rs \
      --replace-fail '/usr/share/backgrounds/pop/kate-hazen-COSMIC-desktop-wallpaper.png' "${cosmic-wallpapers}/share/backgrounds/cosmic/orion_nebula_nasa_heic0601a.jpg"
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-l5y9bOG/h24EfiAFfVKjtzYCzjxU2TI8wh6HBUwoVcE=";

  separateDebugInfo = true;

  nativeBuildInputs = [
    pkg-config
    libcosmicAppHook
  ];

  buildInputs = [
    libinput
    libgbm
    udev
  ];

  dontCargoInstall = true;

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CARGO_TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

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
        "--version"
        "unstable"
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-workspaces-epoch";
    description = "Workspaces Epoch for the COSMIC Desktop Environment";
    mainProgram = "cosmic-workspaces";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.cosmic.members;
    platforms = lib.platforms.linux;
  };
})
