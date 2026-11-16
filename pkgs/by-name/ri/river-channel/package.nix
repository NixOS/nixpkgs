{
  lib,
  stdenv,
  fetchFromCodeberg,
  zig_0_17,
  pkg-config,
  wayland-scanner,
  wayland-protocols,
  wayland,
  river,
  libxkbcommon,
  nix-update-script,
}:

let
  zig = zig_0_17;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "river-channel";
  version = "0.5.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromCodeberg {
    owner = "Sivecano";
    repo = "channel";
    tag = finalAttrs.version;
    hash = "sha256-4OhtFcveAYuolOedTWetDDHffaFPmLsPieBWyUE5nvw=";
  };

  nativeBuildInputs = [
    zig
    pkg-config
  ];

  buildInputs = [
    # wayland-scanner must be placed in buildInputs in order for build to succeed
    wayland-scanner
    wayland-protocols
    wayland
    river
    libxkbcommon
  ];

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-bKADg3LwI3ehAyIGRX6vw9dutOXXmrDQ0NkDotI6eZw=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Input config for river";
    homepage = "https://codeberg.org/Sivecano/channel";
    changelog = "https://codeberg.org/Sivecano/channel/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      OulipianSummer
      atemu
    ];
    mainProgram = "channel";
  };
})
