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
  version = "0.4.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Sivecano";
    repo = "channel";
    tag = finalAttrs.version;
    hash = "sha256-sNCdZ486I27nYQOgzQIF1W/Gdfade1Va9ej7RUkt2K8=";
  };

  patches = [
    # Doesn't find the xkb header otherwise
    (fetchpatch {
      url = "https://codeberg.org/Sivecano/channel/commit/eb36892f7903c91a3584a89df77bd045cb466c71.patch";
      hash = "sha256-pFucr7lfUillewKGKmcfsDezxdtryJuCeS6COVRMUVw=";
    })
  ];

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
