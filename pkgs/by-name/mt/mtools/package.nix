{
  lib,
  stdenv,
  fetchurl,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "mtools";
  version = "4.0.48";

  src = fetchurl {
    url = "mirror://gnu/mtools/${pname}-${version}.tar.bz2";
    hash = "sha256-A8KarIc13XFUqYn7wp6vK1BhIa4cOjXNC/KgLpTScak=";
  };

  patches = lib.optional stdenv.hostPlatform.isDarwin ./UNUSED-darwin.patch;

  # fails to find X on darwin
  configureFlags = lib.optional stdenv.hostPlatform.isDarwin "--without-x";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  enableParallelBuilding = true;

  doCheck = true;

  passthru = {
    updateScript = ./update.sh;
  };

  meta = with lib; {
    homepage = "https://www.gnu.org/software/mtools/";
    description = "Utilities to access MS-DOS disks";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
