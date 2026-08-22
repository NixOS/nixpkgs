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
  dbus,
  callPackage,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rhine";
  version = "0.3.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "sivecano";
    repo = "rhine";
    tag = finalAttrs.version;
    hash = "sha256-1urSOudD12Ge/hy3mGFfGNQAKLjqvuyV+cO1T4HloYs=";
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
    dbus
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
