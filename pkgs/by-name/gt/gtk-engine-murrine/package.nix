{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  intltool,
  gtk2,
}:

stdenv.mkDerivation rec {
  pname = "gtk-engine-murrine";
  version = "0.98.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "129cs5bqw23i76h3nmc29c9mqkm9460iwc8vkl7hs4xr07h8mip9";
  };

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    intltool
  ];
  buildInputs = [ gtk2 ];

  meta = {
    description = "Very flexible theme engine";
    homepage = "https://gitlab.gnome.org/Archive/murrine";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
  };
}
