{
  lib,

  fcft,
  fetchFromCodeberg,
  libxkbcommon,
  nix-update-script,
  pixman,
  pkg-config,
  scdoc,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zig,

  withManpages ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "beansprout";
  version = "1.2.0-unstable-2026-09-21";
  __structuredAttrs = true;
  strictDeps = true;

  outputs = [ "out" ] ++ lib.optional withManpages "man";

  src = fetchFromCodeberg {
    owner = "beansprout";
    repo = "beansprout";
    rev = "8e5c831196f66e2395ce4c25a6cee0ed380306a5";
    hash = "sha256-MH8Hg3UAtkeYunSrITGVGOu4Q/lhoJIP7ywIPvODxrE=";
  };

  buildInputs = [
    wayland
    wayland-protocols
    wayland-scanner
    pixman
    libxkbcommon
    fcft
  ];

  nativeBuildInputs = [
    zig
    pkg-config
  ]
  ++ lib.optional withManpages scdoc;

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-dFDGjDcbcQ4Adi4ufmLWbv5ciHEUmKU4+FSV6z7AVlQ=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "beansprout";
    inherit (zig.meta) platforms;

    description = "DWM-style tiling window manager with built-in wallpaper and a clock/bar, written in Zig with configuration in Kdl";
    homepage = "https://codeberg.org/beansprout/beansprout";
    license = with lib.licenses; [
      # Source code
      gpl3Only
      # Documenation
      cc-by-40
      # stb_image.h
      mit
      unlicense
      # flags.zig
      bsd0
    ];

    maintainers = [ lib.maintainers.lukaswrz ];
  };
})
