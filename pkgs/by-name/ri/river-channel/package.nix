{
  lib,
  stdenv,
  fetchFromGitea,
  fetchpatch,
  zig,
  pkg-config,
  wayland-scanner,
  wayland-protocols,
  wayland,
  river,
  libxkbcommon,
  callPackage,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "river-channel";
  version = "0.4.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Sivecano";
    repo = "channel";
    tag = finalAttrs.version;
    hash = "sha256-AIP5SO7p2Z8fYeLSoIliSya2fQALV1xkkYfIRdHY6TQ=";
  };

  nativeBuildInputs = [
    zig
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland-scanner
    wayland-protocols
    wayland
    river
    libxkbcommon
  ];

  deps = callPackage ./build.zig.zon.nix { };
  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Input config for river";
    homepage = "https://codeberg.org/Sivecano/channel";
    changelog = "https://codeberg.org/Sivecano/channel/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "river-channel";
    inherit (zig.meta) platforms;
  };
})
