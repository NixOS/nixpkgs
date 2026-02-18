{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  pkg-config,
  util-linuxMinimal,
  dbus,
  glib,
  libinput,
  pulseaudio,
  pipewire,
  udev,
  xkeyboard_config,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-applets";
  version = "1.0.6";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applets";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-ZL7Rt0UeWiMaALCIy/eDY5ROTm83xqRymiCupyvx9yI=";
  };

  cargoHash = "sha256-n83JK/pOEMLTBlh0bbFqyW10usEthrSiXoozqmkUa58=";

  nativeBuildInputs = [
    just
    pkg-config
    util-linuxMinimal
    libcosmicAppHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    dbus
    glib
    libinput
    pulseaudio
    pipewire
    udev
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "target"
    "${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ];

  preFixup = ''
    libcosmicAppWrapperArgs+=(
      --set-default X11_BASE_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.xml
      --set-default X11_EXTRA_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.extras.xml
    )
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
    homepage = "https://github.com/pop-os/cosmic-applets";
    description = "Applets for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
  };
})
