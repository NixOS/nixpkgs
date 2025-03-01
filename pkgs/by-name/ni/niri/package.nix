{
  lib,
  dbus,
  eudev,
  fetchFromGitHub,
  libdisplay-info,
  libglvnd,
  libinput,
  libxkbcommon,
  libgbm,
  versionCheckHook,
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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "niri";
  version = "25.02";

  src = fetchFromGitHub {
    owner = "YaLTeR";
    repo = "niri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mTTHA0RAaQcdYe+9A3Jx77cmmyLFHmRoZdd8RpWa+m8=";
  };

  postPatch = ''
    patchShebangs resources/niri-session
    substituteInPlace resources/niri.service \
      --replace-fail '/usr/bin' "$out/bin"
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-xUjBQ65INi5qD7s5SpPw9TISgY6I3bjjUBmpubvM43I=";

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      libdisplay-info
      libglvnd # For libEGL
      libinput
      libxkbcommon
      libgbm
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
    + lib.optionalString (withSystemd || withDinit) ''
      install -Dm0755 resources/niri-session -t $out/bin
    ''
    + lib.optionalString withSystemd ''
      install -Dm0644 resources/niri{-shutdown.target,.service} -t $out/lib/systemd/user
    ''
    + lib.optionalString withDinit ''
      install -Dm0644 resources/dinit/niri{-shutdown,} -t $out/lib/dinit.d/user
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

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    providedSessions = [ "niri" ];
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Scrollable-tiling Wayland compositor";
    homepage = "https://github.com/YaLTeR/niri";
    changelog = "https://github.com/YaLTeR/niri/releases/tag/v${finalAttrs.version}";
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
})
