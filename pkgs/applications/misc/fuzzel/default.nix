{ stdenv, lib, fetchgit, pkg-config, meson, ninja, wayland, pixman, cairo, librsvg, wayland-protocols, wlroots, libxkbcommon, scdoc, git, tllist, fcft}:

stdenv.mkDerivation rec {
  pname = "fuzzel";
  version = "1.4.1";

  src = fetchgit {
    url = "https://codeberg.org/dnkl/fuzzel";
    rev = "${version}";
    sha256 = "18pg46xry7q4i19mpjfz942c6vkqlrj4q18p85zldzv9gdsxnm9c";
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
