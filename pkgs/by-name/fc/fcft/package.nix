{
  stdenv,
  lib,
  fetchFromGitea,
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

stdenv.mkDerivation rec {
  pname = "fcft";
  version = "3.3.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "fcft";
    rev = version;
    hash = "sha256:08fr6zcqk4qp1k3r0di6v60qfyd3q5k9jnxzlsx2p1lh0nils0xa";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    scdoc
  ];
  buildInputs =
    [
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
  mesonFlags =
    [
      (lib.mesonEnable "system-nanosvg" true)
    ]
    ++ builtins.map (
      t: lib.mesonEnable "${t}-shaping" (lib.elem t withShapingTypes)
    ) availableShapingTypes;

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
    changelog = "https://codeberg.org/dnkl/fcft/releases/tag/${version}";
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
}
