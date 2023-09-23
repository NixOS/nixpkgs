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

stdenv.mkDerivation rec {
  pname = "fuzzel";
  version = "1.9.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = pname;
    rev = version;
    hash = "sha256-X1P/ghX97KCQcrNk44Cy2IAGuZ8DDwHBWzh1AHLDvd4=";
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
    changelog = "https://codeberg.org/dnkl/fuzzel/releases/tag/${version}";
    description = "Wayland-native application launcher, similar to rofi’s drun mode";
    homepage = "https://codeberg.org/dnkl/fuzzel";
    license = with licenses; [ mit zlib ];
    mainProgram = "fuzzel";
    maintainers = with maintainers; [ fionera polykernel rodrgz ];
    platforms = with platforms; linux;
  };
}
