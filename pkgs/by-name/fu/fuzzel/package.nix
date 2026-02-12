{
  stdenv,
  lib,
  fetchFromCodeberg,
  pkg-config,
  meson,
  ninja,
  wayland-scanner,
  wayland,
  pixman,
  wayland-protocols,
  libxkbcommon,
  scdoc,
  tllist,
  fcft,
  enableCairo ? true,
  pngSupport ? true,
  svgSupport ? true,
  svgBackend ? "resvg", # alternative: "librsvg", "nanosvg"
  # Optional dependencies
  cairo,
  resvg,
  libpng,
  librsvg,
}:

assert (svgSupport && svgBackend == "nanosvg") -> enableCairo;

stdenv.mkDerivation (finalAttrs: {
  pname = "fuzzel";
  version = "1.14.0";

  src = fetchFromCodeberg {
    owner = "dnkl";
    repo = "fuzzel";
    rev = finalAttrs.version;
    hash = "sha256-9O6CABh149ZtNu3sEhuycsM7pinVrBzU+rLxCAbxobs=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    meson
    ninja
    scdoc
  ];

  buildInputs = [
    wayland
    pixman
    wayland-protocols
    libxkbcommon
    tllist
    fcft
  ]
  ++ lib.optional enableCairo cairo
  ++ lib.optional pngSupport libpng
  ++ lib.optional (svgSupport && svgBackend == "librsvg") librsvg
  ++ lib.optional (svgSupport && svgBackend == "resvg") resvg;

  mesonBuildType = "release";

  mesonFlags = [
    (lib.mesonEnable "enable-cairo" enableCairo)
    (lib.mesonOption "png-backend" (if pngSupport then "libpng" else "none"))
    (lib.mesonOption "svg-backend" (if svgSupport then svgBackend else "none"))
  ];

  meta = {
    changelog = "https://codeberg.org/dnkl/fuzzel/releases/tag/${finalAttrs.version}";
    description = "Wayland-native application launcher, similar to rofi’s drun mode";
    homepage = "https://codeberg.org/dnkl/fuzzel";
    license = with lib.licenses; [
      mit
      zlib
    ];
    mainProgram = "fuzzel";
    maintainers = with lib.maintainers; [
      fionera
      rodrgz
    ];
    platforms = with lib.platforms; linux;
  };
})
