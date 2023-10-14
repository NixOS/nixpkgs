{ stdenv
, lib
, fetchurl
, guile
, autoreconfHook
, guile-gcrypt
, guile-lzma
, guile-quickcheck
, pkg-config
, zlib
}:

stdenv.mkDerivation rec {
  pname = "guile-disarchive";
  version = "0.5.0";

  src = fetchurl {
    url = "https://files.ngyro.com/disarchive/disarchive-${version}.tar.gz";
    hash = "sha256-Agt7v5HTpaskXuYmMdGDRIolaqCHUpwd/CfbZCe9Ups=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
  ];

  buildInputs = [
    guile
    zlib
  ];

  propagatedBuildInputs = [
    guile-gcrypt
    guile-lzma
  ];

  nativeCheckInputs = [ guile-quickcheck ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Disassemble software into data and metadata";
    homepage = "https://ngyro.com/software/disarchive.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = guile.meta.platforms;
  };
}
