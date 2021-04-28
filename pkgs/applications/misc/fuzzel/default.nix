{ stdenv, lib, fetchzip, pkg-config, meson, ninja, wayland, pixman, cairo, librsvg, wayland-protocols, wlroots, libxkbcommon, scdoc, git, tllist, fcft}:

stdenv.mkDerivation rec {
  pname = "fuzzel";
  version = "1.5.1";

  src = fetchzip {
    url = "https://codeberg.org/dnkl/fuzzel/archive/${version}.tar.gz";
    sha256 = "0zy0icd3647jyq4xflp35vwn52yxgj3zz4n30br657xjq1l5afzl";
  };

  nativeBuildInputs = [ pkg-config meson ninja scdoc git ];
  buildInputs = [ wayland pixman cairo librsvg wayland-protocols  wlroots libxkbcommon tllist fcft ];

  meta = with lib; {
    description = "Wayland-native application launcher, similar to rofi’s drun mode";
    homepage = "https://codeberg.org/dnkl/fuzzel";
    license = licenses.mit;
    maintainers = with maintainers; [ fionera ];
    platforms = with platforms; linux;
    changelog = "https://codeberg.org/dnkl/fuzzel/releases/tag/${version}";
  };
}
