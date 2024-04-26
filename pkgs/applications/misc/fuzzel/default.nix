{ stdenv
, lib
, fetchFromGitea
, pkg-config
, meson
, ninja
, wayland-scanner
, wayland
, pixman
, wayland-protocols
, libxkbcommon
, scdoc
, tllist
, fcft
, enableCairo ? true
, svgSupport ? true
, pngSupport ? true
# Optional dependencies
, cairo
, libpng
}:

assert svgSupport -> enableCairo;

stdenv.mkDerivation (finalAttrs: {
  pname = "fuzzel";
  version = "1.10.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "fuzzel";
    rev = finalAttrs.version;
    hash = "sha256-I+h93/I1Kra2S5QSi2XgICAVrcUmO9cmb8UttVuzjwg=";
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
  ] ++ lib.optional enableCairo cairo
    ++ lib.optional pngSupport libpng;

  mesonBuildType = "release";

  mesonFlags = [
    "-Denable-cairo=${if enableCairo then "enabled" else "disabled"}"
    "-Dpng-backend=${if pngSupport then "libpng" else "none"}"
    "-Dsvg-backend=${if svgSupport then "nanosvg" else "none"}"
  ];

  meta = with lib; {
    changelog = "https://codeberg.org/dnkl/fuzzel/releases/tag/${finalAttrs.version}";
    description = "Wayland-native application launcher, similar to rofi’s drun mode";
    homepage = "https://codeberg.org/dnkl/fuzzel";
    license = with licenses; [ mit zlib ];
    mainProgram = "fuzzel";
    maintainers = with maintainers; [ fionera polykernel rodrgz ];
    platforms = with platforms; linux;
  };
})
