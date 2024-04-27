{ lib
, stdenv
, fetchurl
, autoreconfHook
, guile
, pkg-config
, texinfo
, lzlib
}:

stdenv.mkDerivation rec {
  pname = "guile-lzlib";
  version = "0.0.2";

  src = fetchurl {
    url = "https://notabug.org/guile-lzlib/guile-lzlib/archive/${version}.tar.gz";
    hash = "sha256-hiPbd9RH57n/v8vCiDkOcGprGomxFx2u1gh0z+x+T4c=";
  };

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook guile pkg-config texinfo ];
  propagatedBuildInputs = [ guile lzlib ];

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  # tests fail on darwin
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "A GNU Guile library providing bindings to lzlib";
    homepage = "https://notabug.org/guile-lzlib/guile-lzlib";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = guile.meta.platforms;
  };
}
