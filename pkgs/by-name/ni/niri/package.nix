{
  lib,
  clang,
  dbus,
  eudev,
  fetchFromGitHub,
  libdisplay-info,
  libglvnd,
  libinput,
  libxkbcommon,
  mesa,
  nix-update-script,
  pango,
  pipewire,
  pkg-config,
  rustPlatform,
  seatd,
  systemd,
  wayland,
  withDbus ? true,
  withDinit ? false,
  withScreencastSupport ? true,
  withSystemd ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "niri";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "YaLTeR";
    repo = "niri";
    rev = "refs/tags/v${version}";
    hash = "sha256-4YDrKMwXGVOBkeaISbxqf24rLuHvO98TnqxWYfgiSeg=";
  };

  postPatch = ''
    patchShebangs resources/niri-session
    substituteInPlace resources/niri.service \
      --replace-fail '/usr/bin' "$out/bin"
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "smithay-0.3.0" = "sha256-/3BO66yVoo63+5rwrZzoxhSTncvLyHdvtSaApFj3fBg=";
      "libspa-0.8.0" = "sha256-R68TkFbzDFA/8Btcar+0omUErLyBMm4fsmQlCvfqR9o=";
    };
  };

  strictDeps = true;

  nativeBuildInputs = [
    clang
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      libdisplay-info
      libglvnd # For libEGL
      libinput
      libxkbcommon
      mesa # For libgbm
      pango
      seatd
      wayland # For libwayland-client
    ]
    ++ lib.optional (withDbus || withScreencastSupport || withSystemd) dbus
    ++ lib.optional withScreencastSupport pipewire
    ++ lib.optional withSystemd systemd # Includes libudev
    ++ lib.optional (!withSystemd) eudev; # Use an alternative libudev implementation when building w/o systemd

  buildFeatures =
    lib.optional withDbus "dbus"
    ++ lib.optional withDinit "dinit"
    ++ lib.optional withScreencastSupport "xdp-gnome-screencast"
    ++ lib.optional withSystemd "systemd";
  buildNoDefaultFeatures = true;

  postInstall =
    ''
      install -Dm0644 resources/niri.desktop -t $out/share/wayland-sessions
    ''
    + lib.optionalString withDbus ''
      install -Dm0644 resources/niri-portals.conf -t $out/share/xdg-desktop-portal
    ''
    + lib.optionalString withSystemd ''
      install -Dm0755 resources/niri-session -t $out/bin
      install -Dm0644 resources/niri{-shutdown.target,.service} -t $out/share/systemd/user
    '';

  env = {
    # Force linking with libEGL and libwayland-client
    # so they can be discovered by `dlopen()`
    RUSTFLAGS = toString (
      map (arg: "-C link-arg=" + arg) [
        "-Wl,--push-state,--no-as-needed"
        "-lEGL"
        "-lwayland-client"
        "-Wl,--pop-state"
      ]
    );
  };

  passthru = {
    providedSessions = [ "niri" ];
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Scrollable-tiling Wayland compositor";
    homepage = "https://github.com/YaLTeR/niri";
    changelog = "https://github.com/YaLTeR/niri/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      iogamaster
      foo-dogsquared
      sodiboo
      getchoo
    ];
    mainProgram = "niri";
    platforms = lib.platforms.linux;
  };
}
