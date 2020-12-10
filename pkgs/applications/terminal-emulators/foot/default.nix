{ stdenv, fetchgit
, fcft, freetype, pixman, libxkbcommon, fontconfig, wayland
, meson, ninja, ncurses, scdoc, tllist, wayland-protocols, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "foot";
  version = "1.5.4";

  src = fetchgit {
    url = "https://codeberg.org/dnkl/foot.git";
    rev = version;
    sha256 = "0y6xfsldz5lwy6kp5dy9s27pnii7n5zj754wglvz9d9fp5lkl6id";
  };

  nativeBuildInputs = [
    meson ninja ncurses scdoc tllist wayland-protocols pkg-config
  ];
  buildInputs = [
    fontconfig freetype pixman wayland libxkbcommon fcft
  ];

  # recommended build flags for foot as per INSTALL.md
  # https://codeberg.org/dnkl/foot/src/branch/master/INSTALL.md#user-content-release-build
  preConfigure = ''
    export CFLAGS+=" -O3 -fno-plt"
  '';

  mesonFlags = [ "--buildtype=release" "-Db_lto=true" ];

  meta = with stdenv.lib; {
    homepage = "https://codeberg.org/dnkl/foot/";
    changelog = "https://codeberg.org/dnkl/foot/releases/tag/${version}";
    description = "A fast, lightweight and minimalistic Wayland terminal emulator";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.linux;
  };
}
