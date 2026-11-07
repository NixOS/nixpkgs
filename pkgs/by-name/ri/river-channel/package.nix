{
  lib,
  stdenv,
  fetchFromCodeberg,
  zig_0_16,
  pkg-config,
  wayland-scanner,
  wayland-protocols,
  wayland,
  river,
  libxkbcommon,
  nix-update-script,
}:

let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "river-channel";
  version = "0.5.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromCodeberg {
    owner = "Sivecano";
    repo = "channel";
    tag = finalAttrs.version;
    hash = "sha256-IgSkB+0D6JIBQGTHyynS80UaA4Wnrxl8MJQQJaKESLg=";
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
    hash = "sha256-PTmOcKLX9H87yBLI7fbUgPQ0+eUTTjnvdsYar3aLhN4=";
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
