{
  callPackage,
  fetchFromSourcehut,
  lib,
  pandoc,
  pkg-config,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zig_0_14,
}:

let
  zig = zig_0_14;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "river-ultitile";
  version = "1.3.0";

  src = fetchFromSourcehut {
    owner = "~midgard";
    repo = "river-ultitile";
    rev = "v${finalAttrs.version}";
    hash = "sha256-whzJZLgd51kXOVq9YVqcADTOyGmHmwJZWzbrZGZx3Ak=";
  };

  nativeBuildInputs = [
    zig.hook
    pkg-config
    wayland
    wayland-scanner
  ];

  buildInputs = [
    wayland-protocols
    pandoc # used for building documentation
  ];

  deps = callPackage ./build.zig.zon.nix { };

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  meta = {
    description = "Configurable layout generator for the River compositor";
    longDescription = ''
      A layout generator for **river**. Features include:
      - **configurable** layouts employing nested tiles (no juggling with coordinates),
      - **widescreen** support by default,
      - default layouts, switchable at run time with a command or key binding:
          - dwm-like main/stack layout,
              - main on the left on normal screens,
              - **main in the center and stacks on both sides** on widescreens,
          - a vertical stack,
          - a horizontal stack, and
          - a monocle layout,
      - optional per-tag-per-output state.
    '';
    changelog = "https://git.sr.ht/~midgard/river-ultitile/tree/v${finalAttrs.version}/item/CHANGELOG.md";
    homepage = "https://git.sr.ht/~midgard/river-ultitile";
    license = lib.licenses.gpl3Plus;
    mainProgram = "river-ultitile";
    maintainers = with lib.maintainers; [ debling ];
    platforms = lib.platforms.linux;
  };
})
