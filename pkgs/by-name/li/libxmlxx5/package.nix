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
  pname = "libxml++";
  version = "5.4";

  src = fetchurl {
    url = "https://download.gnome.org/sources/libxml++/${version}/libxml++-${lib.versions.pad 3 version}.tar.xz";
    sha256 = "sha256-6aI8Q2aGqUaY0hOOa8uvhJEh1jv6D1DcNP77/XlWaEg=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [ glibmm ];

  propagatedBuildInputs = [ libxml2 ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://libxmlplusplus.sourceforge.net/";
    description = "C++ wrapper for the libxml2 XML parser library, version 5";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ normalcea ];
  };
}
