{ stdenv, fetchgit
, fcft, freetype, pixman, libxkbcommon, fontconfig, wayland
, meson, ninja, ncurses, scdoc, tllist, wayland-protocols, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "foot";
  version = "1.5.1";

  src = fetchgit {
    url = "https://codeberg.org/dnkl/foot.git";
    rev = version;
    sha256 = "sha256-GAk2qkrgCNILJOeRcn1NT4t3w+R6WFTZ1goOhBEwKwc=";
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
    export CFLAGS+="-O3 -fno-plt"
  '';

  mesonFlags = [ "--buildtype=release" "-Db_lto=true" ];

  meta = with stdenv.lib; {
    homepage = "https://codeberg.org/dnkl/foot/";
    description = "A fast, lightweight and minimalistic Wayland terminal emulator";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.linux;
  };
}
