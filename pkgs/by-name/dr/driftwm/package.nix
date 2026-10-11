{
  autoPatchelfHook,
  fetchFromGitHub,
  lib,
  libGL,
  libdisplay-info,
  libgbm,
  libinput,
  libxkbcommon,
  makeBinaryWrapper,
  nix-update-script,
  pkg-config,
  rustPlatform,
  seatd,
  versionCheckHook,
  vulkan-loader,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "driftwm";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "malbiruk";
    repo = "driftwm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0nYE3W5HI+5bkYD7xQvqRtrjPBcmVOb57PB80jlnloA=";
  };

  cargoHash = "sha256-fza5n3ZiWWHiAuNvaJb27xt2Nwi+pMl/tZVT0zEmaOE=";

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    libdisplay-info
    libgbm
    libinput
    libxkbcommon
    seatd
  ];

  runtimeDependencies = [
    vulkan-loader
    wayland
  ];

  postFixup = ''
    wrapProgram $out/bin/driftwm \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Trackpad-first infinite canvas Wayland compositor";
    longDescription = ''
      Traditional window managers arrange windows to fit your screen.
      driftwm flips this: windows float on an infinite 2D canvas and
      you move the viewport around them.  Designed with laptops in
      mind — trackpad support keeps getting better while display size
      stays limited, so treating your screen as a camera onto a larger
      canvas makes sense.  Pan, zoom, and navigate with trackpad
      gestures.  No workspaces, no tiling — just drift.
    '';
    homepage = "https://github.com/malbiruk/driftwm";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "driftwm";
  };
})
