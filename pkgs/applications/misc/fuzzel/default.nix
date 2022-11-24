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
, librsvg
, libpng
}:

assert svgSupport -> enableCairo;

stdenv.mkDerivation rec {
  pname = "fuzzel";
  version = "1.8.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "fuzzel";
    rev = version;
    sha256 = "sha256-5uXf5HfQ8bDQSMNCHHaC9sCX5P/D89T2ZOUiXTDx3bQ=";
  };

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
    ++ lib.optional pngSupport libpng
    ++ lib.optional svgSupport librsvg;

  mesonBuildType = "release";

  mesonFlags = [
    "-Denable-cairo=${if enableCairo then "enabled" else "disabled"}"
    "-Dpng-backend=${if pngSupport then "libpng" else "none"}"
    "-Dsvg-backend=${if svgSupport then "librsvg" else "none"}"
  ];

  meta = with lib; {
    description = "Wayland-native application launcher, similar to rofi’s drun mode";
    homepage = "https://codeberg.org/dnkl/fuzzel";
    license = licenses.mit;
    maintainers = with maintainers; [ fionera polykernel ];
    platforms = with platforms; linux;
    changelog = "https://codeberg.org/dnkl/fuzzel/releases/tag/${version}";
  };
}
