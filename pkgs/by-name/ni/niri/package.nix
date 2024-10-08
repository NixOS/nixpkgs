{
  lib,
  autoPatchelfHook,
  clang,
  dbus,
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
}:

rustPlatform.buildRustPackage rec {
  pname = "niri";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "YaLTeR";
    repo = "niri";
    rev = "v${version}";
    hash = "sha256-4YDrKMwXGVOBkeaISbxqf24rLuHvO98TnqxWYfgiSeg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "smithay-0.3.0" = "sha256-/3BO66yVoo63+5rwrZzoxhSTncvLyHdvtSaApFj3fBg=";
      "libspa-0.8.0" = "sha256-R68TkFbzDFA/8Btcar+0omUErLyBMm4fsmQlCvfqR9o=";
    };
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    clang
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    dbus
    libdisplay-info
    libinput
    libxkbcommon
    mesa # For libgbm
    pango
    pipewire
    seatd
    systemd # Also includes libudev
  ];

  runtimeDependencies = [
    wayland
    libglvnd # For libEGL
  ];

  passthru.providedSessions = [ "niri" ];

  postPatch = ''
    patchShebangs ./resources/niri-session
    substituteInPlace ./resources/niri.service \
      --replace-fail '/usr/bin' "$out/bin"
  '';

  postInstall = ''
    install -Dm0755 ./resources/niri-session -t $out/bin
    install -Dm0644 resources/niri.desktop -t $out/share/wayland-sessions
    install -Dm0644 resources/niri-portals.conf -t $out/share/xdg-desktop-portal
    install -Dm0644 resources/niri{-shutdown.target,.service} -t $out/share/systemd/user
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Scrollable-tiling Wayland compositor";
    homepage = "https://github.com/YaLTeR/niri";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      iogamaster
      foo-dogsquared
      sodiboo
    ];
    mainProgram = "niri";
    platforms = platforms.linux;
  };
}
