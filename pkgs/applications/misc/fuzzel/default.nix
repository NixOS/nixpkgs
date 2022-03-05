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
, withPNGBackend ? "libpng"
, withSVGBackend ? "librsvg"
  # Optional dependencies
, cairo
, librsvg
, libpng
}:

stdenv.mkDerivation rec {
  pname = "fuzzel";
  version = "1.7.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "fuzzel";
    rev = version;
    sha256 = "1261gwxiky37pvzmmbrpml1psa22kkglb141ybj1fbnwg6j7jvlf";
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
  ++ lib.optional (withPNGBackend == "libpng") libpng
  ++ lib.optional (withSVGBackend == "librsvg") librsvg;

  mesonBuildType = "release";

  mesonFlags = [
    "-Denable-cairo=${if enableCairo then "enabled" else "disabled"}"
    "-Dpng-backend=${withPNGBackend}"
    "-Dsvg-backend=${withSVGBackend}"
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
