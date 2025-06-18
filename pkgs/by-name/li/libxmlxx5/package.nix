{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxml2,
  glibmm,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "libxmlxx5";
  version = "5.4";

  src = fetchurl {
    url = "mirror://gnome/sources/libxml++/${version}/libxml++-${lib.versions.pad 3 version}.tar.xz";
    hash = "sha256-6aI8Q2aGqUaY0hOOa8uvhJEh1jv6D1DcNP77/XlWaEg=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [ glibmm ];

  propagatedBuildInputs = [ libxml2 ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = {
    description = "C++ wrapper for the libxml2 XML parser library";
    homepage = "https://libxmlplusplus.sourceforge.net/";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ lib.maintainers.normalcea ];
    platforms = lib.platforms.unix;
  };
}
