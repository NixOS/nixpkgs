{
  lib,
  stdenv,
  fetchFromGitHub,
  fcft,
  kwim,
  libxkbcommon,
  nix-update-script,
  pixman,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  writeText,
  zig_0_16,
  conf ? null,
}:

let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kwm";
  version = "0.3.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "kewuaa";
    repo = "kwm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hX76wTHPTgg5RAHILfd3CjRKPlgAwGSK3lG82IFoUUs=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-Lz/Wcy40rxN81n/mBj4YJVbyGOolHzSFZMs93T1h0oQ=";
  };

  postPatch =
    let
      configFile =
        if lib.isDerivation conf || builtins.isPath conf then conf else writeText "config.zon" conf;
    in
    ''
      # Spawn kwim, the companion input manager, without relying on PATH
      substituteInPlace src/kwm/seat.zig \
        --replace-fail 'ctx.spawn(&.{ "kwim" })' 'ctx.spawn(&.{ "${lib.getExe kwim}" })'
    ''
    + lib.optionalString (conf != null) "cp ${configFile} config.zon";

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    zig
  ];

  buildInputs = [
    fcft
    libxkbcommon
    pixman
    wayland
    wayland-protocols
    wayland-scanner
  ];

  passthru = {
    providedSessions = [ "kwm" ];
    updateScript = nix-update-script { };
  };

  meta = {
    description = "DWM-like dynamic tiling window manager implementing the river-window-management-v1 protocol";
    homepage = "https://github.com/kewuaa/kwm";
    changelog = "https://github.com/kewuaa/kwm/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      # Source code
      gpl3Only

      # Wayland protocols
      mit

      # Logo and icons
      cc-by-sa-40
    ];
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "kwm";
    platforms = lib.platforms.linux;
  };
})
