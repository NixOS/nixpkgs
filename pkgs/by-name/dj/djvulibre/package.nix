{
  lib,
  stdenv,
  fetchurl,
  libjpeg,
  libtiff,
  librsvg,
  libiconv,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "djvulibre";
  version = "3.5.29";

  src = fetchurl {
    url = "mirror://sourceforge/djvu/${pname}-${version}.tar.gz";
    hash = "sha256-07SwOuK9yoUWo2726ye3d/BSjJ7aJnRdmWKCSj/f7M8=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
    "lib"
    "man"
  ];

  strictDeps = true;
  nativeBuildInputs = [
    librsvg
  ];

  buildInputs = [
    libjpeg
    libtiff
    libiconv
    bash
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Big set of CLI tools to make/modify/optimize/show/export DJVU files";
    homepage = "https://djvu.sourceforge.net";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ Anton-Latukha ];
    platforms = platforms.all;
  };
}
