{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxml2,
  glibmm_2_4,
  perl,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "libxml++";
  version = "2.40.1";

  src = fetchurl {
    url = "mirror://gnome/sources/libxml++/${lib.versions.majorMinor version}/libxml++-${version}.tar.xz";
    hash = "sha256-StSr3TJYh09hwuKkHQjpkwZ3l20wNlPNFnDT6fNUY+k=";
  };

  configureFlags = [
    # remove if library is updated
    "CXXFLAGS=-std=c++11"
  ];

  outputs = [
    "out"
    "devdoc"
  ];

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  propagatedBuildInputs = [
    libxml2
    glibmm_2_4
  ];

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "libxmlxx";
      packageName = "libxml++";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = {
    homepage = "https://libxmlplusplus.sourceforge.net/";
    description = "C++ wrapper for the libxml2 XML parser library";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
