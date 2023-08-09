{ lib, stdenv
, fetchurl
, libjpeg
, libtiff
, librsvg
, libiconv
, bash
}:

stdenv.mkDerivation rec {
  pname = "djvulibre";
  version = "3.5.28";

  src = fetchurl {
    url = "mirror://sourceforge/djvu/${pname}-${version}.tar.gz";
    sha256 = "1p1fiygq9ny8aimwc4vxwjc6k9ykgdsq1sq06slfbzalfvm0kl7w";
  };

  outputs = [ "bin" "dev" "out" ];

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
    description = "The big set of CLI tools to make/modify/optimize/show/export DJVU files";
    homepage = "https://djvu.sourceforge.net";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ Anton-Latukha ];
    platforms = platforms.all;
  };
}
