{
  autoPatchelfHook,
  fetchFromGitHub,
  lib,
  libdisplay-info_0_3,
  libdrm,
  libgbm,
  libglvnd,
  libinput,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxkbcommon,
  libxrandr,
  nix-update-script,
  nixosTests,
  pkg-config,
  rustPlatform,
  seatd,
  stdenv,
  systemd,
  versionCheckHook,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "driftwm";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "malbiruk";
    repo = "driftwm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GHWGpz1vwPVpZtXOLupZZGTyCnCUf55/AdwO1zZ68cM=";
  };

  cargoHash = "sha256-aXG3QQ8RAiqpxezXIMDfK4RwYAYR2UHAM7W/3cUdcGc=";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
  ];

  # Based on upstream's flake.nix
  buildInputs = [
    # libdisplay-info-sys requires libdisplay-info below 0.4
    libdisplay-info_0_3
    libdrm
    libgbm
    libglvnd
    libinput
    libx11
    libxcb
    libxcursor
    libxi
    libxkbcommon
    libxrandr
    seatd
    systemd
    wayland
  ];

  # Libraries loaded with dlopen at runtime
  runtimeDependencies = [
    libglvnd
    libx11
    libxcb
    libxcursor
    libxi
    libxkbcommon
    libxrandr
    wayland
  ];

  # Tests dlopen libwayland-client before autoPatchelfHook runs
  preCheck = ''
    export LD_LIBRARY_PATH=${lib.makeLibraryPath [ wayland ]}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
  '';

  # Cargo builds into a per-target directory, so point the Makefile at it
  postInstall = ''
    make install PREFIX=$out SYSCONFDIR=$out/etc \
      TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}

    substituteInPlace $out/share/wayland-sessions/driftwm.desktop \
      --replace-fail "Exec=driftwm-session" "Exec=$out/bin/driftwm-session"
    substituteInPlace $out/lib/systemd/user/driftwm.service \
      --replace-fail "ExecStart=driftwm" "ExecStart=$out/bin/driftwm"

    # Point the example wallpaper paths at the NixOS system profile
    substituteInPlace $out/etc/driftwm/config.reference.toml \
      --replace-fail "/usr/local/share/driftwm" "/run/current-system/sw/share/driftwm"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    providedSessions = [ "driftwm" ];
    tests = { inherit (nixosTests) driftwm; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Trackpad-first infinite canvas Wayland compositor";
    longDescription = ''
      Traditional window managers arrange windows to fit your screen.
      driftwm flips this: windows float on an infinite 2D canvas and
      you move the viewport around them.  Designed with laptops in
      mind; trackpad support keeps getting better while display size
      stays limited, so treating your screen as a camera onto a larger
      canvas makes sense.  Pan, zoom, and navigate with trackpad
      gestures.  No workspaces, no tiling, just drift.
    '';
    homepage = "https://github.com/malbiruk/driftwm";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "driftwm";
    platforms = lib.platforms.linux;
  };
})
