{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "lib3ds";
  version = "1.3.0";

  src = fetchurl {
    url = "http://lib3ds.googlecode.com/files/lib3ds-${version}.zip";
    sha256 = "1qr9arfdkjf7q11xhvxwzmhxqz3nhcjkyb8zzfjpz9jm54q0rc7m";
  };

  nativeBuildInputs = [ unzip ];

  meta = {
    description = "Library for managing 3D-Studio Release 3 and 4 \".3DS\" files";
    homepage = "https://lib3ds.sourceforge.net/";
    license = "LGPL";
    platforms = lib.platforms.unix;
  };
}
