{
  stdenv,
  fetchFromCodeberg,
  lib,

  # nativeBuildInputs
  zig_0_16,
  pkg-config,

  # buildInputs
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxkbcommon,

  # passthru
  nix-update-script,
}:
let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rill";
  version = "0.7.0";

  src = fetchFromCodeberg {
    owner = "lzj15";
    repo = "rill";
    rev = "${finalAttrs.version}";
    hash = "sha256-RwHjFImII99ZMNnD0hAK+DmJPnQgZIFcOShhj8wNa+E=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-rOsFulT8MvLIB5UEySl2biLoyMxTUCVbWbIkz4pZ/go=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  nativeBuildInputs = [
    zig
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://codeberg.org/lzj15/rill";
    changelog = "https://codeberg.org/lzj15/rill/src/branch/${finalAttrs.version}/CHANGELOG.md";
    description = "Minimalist scrolling window manager for river";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evanwporter ];
    inherit (wayland.meta) platforms;
    mainProgram = "rill";
  };
})
