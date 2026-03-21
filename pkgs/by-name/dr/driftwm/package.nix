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
  pkg-config,
  rustPlatform,
  pixman,
  seatd,
  systemd,
  versionCheckHook,
  vulkan-loader,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "driftwm";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "malbiruk";
    repo = "driftwm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c/FGLGvP/7M+n41j85IA5OzqKBzzQ532eT7r61HCJJs=";
  };

  cargoHash = "sha256-rtSccFKbikMyeP1lT3Z1921/aKkws27apps2nZ7r6tE=";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
  ];

  # Same set as upstream's flake.nix
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
    pixman
    seatd
    systemd
    wayland
  ];

  # Libraries loaded with dlopen at runtime
  runtimeDependencies = [
    libglvnd
    libx11
    libxcursor
    libxi
    libxkbcommon
    libxrandr
    vulkan-loader
    wayland
  ];

  # Tests dlopen libwayland-client before autoPatchelfHook runs
  preCheck = ''
    export LD_LIBRARY_PATH=${lib.makeLibraryPath [ wayland ]}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
  '';

  # Mirror the install target of upstream's Makefile
  postInstall = ''
    install -Dm755 resources/driftwm-session -t $out/bin
    install -Dm644 resources/driftwm.desktop -t $out/share/wayland-sessions
    install -Dm644 resources/driftwm-portals.conf -t $out/share/xdg-desktop-portal
    install -Dm644 resources/driftwm.service resources/driftwm-shutdown.target \
      -t $out/lib/systemd/user
    install -Dm644 config.reference.toml -t $out/etc/driftwm
    (cd extras/wallpapers && find . -name '*.glsl' -exec \
      install -Dm644 {} $out/share/driftwm/wallpapers/{} \;)

    substituteInPlace $out/share/wayland-sessions/driftwm.desktop \
      --replace-fail "Exec=driftwm-session" "Exec=$out/bin/driftwm-session"
    substituteInPlace $out/lib/systemd/user/driftwm.service \
      --replace-fail "ExecStart=driftwm" "ExecStart=$out/bin/driftwm"
  '';

  passthru.providedSessions = [ "driftwm" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

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
  };
})
