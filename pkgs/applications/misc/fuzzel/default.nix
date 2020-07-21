{ stdenv, lib, fetchgit, pkg-config, meson, ninja, wayland, pixman, cairo, librsvg, wayland-protocols, wlroots, libxkbcommon, scdoc, git, tllist, fcft}:

stdenv.mkDerivation rec {
  pname = "fuzzel";
  version = "1.3.0";

  src = fetchgit {
    url = "https://codeberg.org/dnkl/fuzzel";
    rev = "${version}";
    sha256 = "12jv5iwmksygw8nfkxbd9rbi03wnpgb30hczq009aqgy7lyi5zmp";
  };

  nativeBuildInputs = [ pkg-config meson ninja scdoc git ];
  buildInputs = [ wayland pixman cairo librsvg wayland-protocols  wlroots libxkbcommon tllist fcft ];

  meta = with lib; {
    description = "Wayland-native application launcher, similar to rofi’s drun mode";
    homepage = "https://codeberg.org/dnkl/fuzzel";
    license = licenses.mit;
    maintainers = with maintainers; [ fionera ];
    platforms = with platforms; linux;
  };
}
