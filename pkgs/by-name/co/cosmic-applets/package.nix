{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  just,
  pkg-config,
  udev,
  util-linuxMinimal,
  dbus,
  glib,
  libinput,
  libxkbcommon,
  pulseaudio,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-applets";
  version = "1.0.0-alpha.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applets";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-4KaMG7sKaiJDIlP101/6YDHDwKRqJXHdqotNZlPhv8Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-f5OV//qzWQqIvq8BNtd2H1dWl7aqR0WJwmdimL4wcKQ=";

  nativeBuildInputs = [
    just
    pkg-config
    util-linuxMinimal
  ];

  buildInputs = [
    dbus
    glib
    libinput
    libxkbcommon
    pulseaudio
    wayland
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

  # Force linking to libwayland-client, which is always dlopen()ed.
  "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_RUSTFLAGS" =
    map (a: "-C link-arg=${a}")
      [
        "-Wl,--push-state,--no-as-needed"
        "-lwayland-client"
        "-Wl,--pop-state"
      ];

  meta = {
    homepage = "https://github.com/pop-os/cosmic-applets";
    description = "Applets for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      qyliss
      nyabinary
    ];
    platforms = lib.platforms.linux;
  };
})
