{
  stdenv,
  lib,
  fetchFromCodeberg,
  pkg-config,
  meson,
  ninja,
  scdoc,
  freetype,
  fontconfig,
  nanosvg,
  pixman,
  tllist,
  check,
  # Text shaping methods to enable, empty list disables all text shaping.
  # See `availableShapingTypes` or upstream meson_options.txt for available types.
  withShapingTypes ? [
    "grapheme"
    "run"
  ],
  harfbuzz,
  utf8proc,
  fcft, # for passthru.tests
}:

let
  # Needs to be reflect upstream meson_options.txt
  availableShapingTypes = [
    "grapheme"
    "run"
  ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "fcft";
  version = "3.3.3";

  src = fetchFromCodeberg {
    owner = "dnkl";
    repo = "fcft";
    rev = finalAttrs.version;
    hash = "sha256-MkGlph9WpqH4daov5ZZPO2ua2mUbrsuo8Xk6GoKhoxg=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    scdoc
  ];
  buildInputs = [
    freetype
    fontconfig
    nanosvg
    pixman
    tllist
  ]
  ++ lib.optionals (withShapingTypes != [ ]) [ harfbuzz ]
  ++ lib.optionals (builtins.elem "run" withShapingTypes) [ utf8proc ];
  nativeCheckInputs = [ check ];

  mesonBuildType = "release";
  mesonFlags = [
    (lib.mesonEnable "system-nanosvg" true)
  ]
  ++ map (t: lib.mesonEnable "${t}-shaping" (lib.elem t withShapingTypes)) availableShapingTypes;

  doCheck = true;

  outputs = [
    "out"
    "doc"
    "man"
  ];

  passthru.tests = {
    noShaping = fcft.override { withShapingTypes = [ ]; };
    onlyGraphemeShaping = fcft.override { withShapingTypes = [ "grapheme" ]; };
  };

  meta = {
    homepage = "https://codeberg.org/dnkl/fcft";
    changelog = "https://codeberg.org/dnkl/fcft/releases/tag/${finalAttrs.version}";
    description = "Simple library for font loading and glyph rasterization";
    maintainers = with lib.maintainers; [
      fionera
      sternenseemann
    ];
    license = with lib.licenses; [
      mit
      zlib
    ];
    platforms = with lib.platforms; linux;
  };
})
