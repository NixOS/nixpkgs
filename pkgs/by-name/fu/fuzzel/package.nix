{
  stdenv,
  lib,
  fetchFromGitea,
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
  svgBackend ? "nanosvg", # alternative: "librsvg"
  # Optional dependencies
  cairo,
  libpng,
  librsvg,
}:

assert (svgSupport && svgBackend == "nanosvg") -> enableCairo;

stdenv.mkDerivation (finalAttrs: {
  pname = "fuzzel";
  version = "1.11.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "fuzzel";
    rev = finalAttrs.version;
    hash = "sha256-FM5HvPfLVmuKpS3/0m2QM/lSRcWsVpnwtJ++L3Uo5Dc=";
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

  buildInputs =
    [
      wayland
      pixman
      wayland-protocols
      libxkbcommon
      tllist
      fcft
    ]
    ++ lib.optional enableCairo cairo
    ++ lib.optional pngSupport libpng
    ++ lib.optional (svgSupport && svgBackend == "librsvg") librsvg;

  mesonBuildType = "release";

  mesonFlags = [
    (lib.mesonEnable "enable-cairo" enableCairo)
    (lib.mesonOption "png-backend" (if pngSupport then "libpng" else "none"))
    (lib.mesonOption "svg-backend" (if svgSupport then svgBackend else "none"))
  ];

  meta = with lib; {
    changelog = "https://codeberg.org/dnkl/fuzzel/releases/tag/${finalAttrs.version}";
    description = "Wayland-native application launcher, similar to rofi’s drun mode";
    homepage = "https://codeberg.org/dnkl/fuzzel";
    license = with licenses; [
      mit
      zlib
    ];
    mainProgram = "fuzzel";
    maintainers = with maintainers; [
      fionera
      rodrgz
    ];
    platforms = with platforms; linux;
  };
})
