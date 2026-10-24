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
  version = "1.2.0-unstable-2026-10-21";
  __structuredAttrs = true;
  strictDeps = true;

  outputs = [ "out" ] ++ lib.optional withManpages "man";

  src = fetchFromCodeberg {
    owner = "beansprout";
    repo = "beansprout";
    rev = "6d10aeb5a16de79bca1d00b3f8e78d1a3a14e727";
    hash = "sha256-ssfd+eW+amHFl5PLoOZln46XKGO120KlU1q0A36fnw8=";
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
