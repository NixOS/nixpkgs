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
  zig_0_16,

  withManpages ? true,
}:
let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "beansprout";
  version = "1.1.1";
  __structuredAttrs = true;
  strictDeps = true;

  outputs = [ "out" ] ++ lib.optional withManpages "man";

  src = fetchFromCodeberg {
    owner = "beansprout";
    repo = "beansprout";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J8lv/dq85ILOxkWMqrDGDgm8wV3Meqqxk2VlX+T17xQ=";
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

    description = "Dynamic tiling window manager for the River Wayland compositor";
    longDescription = ''
      Beansprout is a DWM-style tiling window manager for the River
      Wayland compositor with a built-in wallpaper and a clock/bar,
      written in Zig with configuration in KDL.
    '';
    homepage = "https://codeberg.org/beansprout/beansprout";
    license =
      with lib.licenses;
      AND (
        [
          gpl3Only
          # stb_image.h
          (OR [
            mit
            unlicense
          ])
          # flags.zig
          bsd0
        ]
        ++ lib.optional withManpages cc-by-40
      );

    maintainers = [ lib.maintainers.lukaswrz ];
  };
})
