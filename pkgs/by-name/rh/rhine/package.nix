{
  lib,
  stdenv,
  fetchFromGitea,
  zig,
  pkg-config,
  wayland,
  wayland-scanner,
  wayland-protocols,
  river,
  libxkbcommon,
  libnotify,
  callPackage,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rhine";
  version = "0.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "sivecano";
    repo = "rhine";
    tag = finalAttrs.version;
    hash = "sha256-8lyssccIwk2+niFwaDa/jJspsgdj9Kjlb2UixsDI5wg=";
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
    libnotify
  ];

  deps = callPackage ./build.zig.zon.nix { };
  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Window manager for river supporting multiple layouts and awesome animations";
    homepage = "https://codeberg.org/sivecano/rhine";
    changelog = "https://codeberg.org/sivecano/rhine/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      atemu
    ];
    mainProgram = "rhine";
    inherit (zig.meta) platforms;
  };
})
