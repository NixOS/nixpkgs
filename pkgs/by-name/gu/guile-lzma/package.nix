{ stdenv
, lib
, fetchurl
, xz
, pkg-config
, guile
, scheme-bytestructures
}:

stdenv.mkDerivation rec {
  pname = "guile-lzma";
  version = "0.1.1";

  src = fetchurl {
    url = "https://files.ngyro.com/guile-lzma/guile-lzma-${version}.tar.gz";
    hash = "sha256-K4ZoltZy7U05AI9LUzZ1DXiXVgoGZ4Nl9cWnK9L8zl4=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    guile
    pkg-config
  ];
  buildInputs = [ guile ];
  propagatedBuildInputs = [ xz ];
  propagatedNativeBuildInputs = [ scheme-bytestructures ];

  doCheck = true;

  # In procedure bytevector-u8-ref: Argument 2 out of range
  dontStrip = stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://ngyro.com/software/guile-lzma.html";
    description = "Guile wrapper for lzma library";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = guile.meta.platforms;
  };
}
