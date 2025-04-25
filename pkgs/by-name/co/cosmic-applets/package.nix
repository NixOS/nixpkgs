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

rustPlatform.buildRustPackage rec {
  pname = "cosmic-applets";
  version = "1.0.0-alpha.7";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applets";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-DmU9Dlb8w3a8U+oSGwWARPh1SRbv/8TW7TO9SSvDe1U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-wWs3B5hh2DP93i+4gGDTi+7NT4bj8ULJ+fT95sXxUdg=";

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

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-applets";
    description = "Applets for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      qyliss
      nyabinary
    ];
    platforms = platforms.linux;
  };
}
