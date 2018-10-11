{ stdenv, callPackage, fetchurl, pkgconfig, cmake, pcre, gtk2, gtk3, dbus-glib, libgudev, lua5_1 }:

let
  libgaminggear = callPackage ./libgaminggear.nix {};
in
  stdenv.mkDerivation rec {
  name = "roccat-tools-${version}";
  version = "5.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/roccat/${name}.tar.bz2";
    sha256 = "15gxplcm62167xhk65k8v6gg3j6jr0c5a64wlz72y1vfq0ai7qm6";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libgaminggear cmake pcre gtk2 gtk3 dbus-glib libgudev lua5_1 ];

  patchPhase = ''
    substituteInPlace roccateventhandler/CMakeLists.txt --replace '/etc/xdg' "$out/etc/xdg"
    substituteInPlace libroccat/roccat_helper.c --replace '"/", "/var", "lib"' 'g_get_user_config_dir()'
  '';

  cmakeFlags = [
    "-DLIBDIR=lib"
    "-DUDEVDIR=lib/udev"
    "-DLUA_FIND_VERSION=5.1"
    "-DLUA_FIND_VERSION_EXACT=1"
    "-DCMAKE_MODULE_PATH=${libgaminggear}/lib/cmake"
  ];

  meta = {
    description = "Userland tools for roccat devices";
    homepage = http://roccat.sourceforge.net;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ashkitten ];
  };
}
