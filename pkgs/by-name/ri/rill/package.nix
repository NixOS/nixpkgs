{
  lib,
  stdenv,
  fetchFromCodeberg,

  # nativeBuildInputs
  pkg-config,
  zig_0_16,

  # buildInputs
  libxkbcommon,
  wayland,
  wayland-protocols,
  wayland-scanner,

  # passthru
  nix-update-script,
}:
let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rill";
  version = "0.7.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "lzj15";
    repo = "rill";
    tag = finalAttrs.version;
    hash = "sha256-KRwvk1yeq1urgNpPH2ZK25orlFE0/KzCKhUsCVVjrhE=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-+FqBKmzOEqhPEykvMhNsuyKTKWc5/x19anbk5LNxokM=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  nativeBuildInputs = [
    pkg-config
    zig
  ];

  buildInputs = [
    libxkbcommon
    wayland
    wayland-protocols
    wayland-scanner
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimalist scrolling window manager for river";
    homepage = "https://codeberg.org/lzj15/rill";
    changelog = "https://codeberg.org/lzj15/rill/src/branch/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      evanwporter
      yiyu
    ];
    inherit (wayland.meta) platforms;
    mainProgram = "rill";
  };
})
