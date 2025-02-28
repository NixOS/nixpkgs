{
  lib,
  stdenv,
  fetchurl,
  cairo,
  expat,
  guile,
  guile-lib,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "guile-cairo";
  version = "1.11.2";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-YjLU3Cxb2dMxE5s7AfQ0PD4fucp4mDYaaZIGcwlBoHs=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    cairo
    expat
    guile
  ];

  enableParallelBuilding = true;

  doCheck = false; # Cannot find unit-test module from guile-lib
  nativeCheckInputs = [ guile-lib ];

  meta = with lib; {
    homepage = "https://www.nongnu.org/guile-cairo/";
    description = "Cairo bindings for GNU Guile";
    longDescription = ''
      Guile-Cairo wraps the Cairo graphics library for Guile Scheme.

      Guile-Cairo is complete, wrapping almost all of the Cairo API.  It is API
      stable, providing a firm base on which to do graphics work.  Finally, and
      importantly, it is pleasant to use.  You get a powerful and well
      maintained graphics library with all of the benefits of Scheme: memory
      management, exceptions, macros, and a dynamic programming environment.
    '';
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = guile.meta.platforms;
  };
}
