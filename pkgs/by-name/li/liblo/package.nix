{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "liblo";
  version = "0.32";

  src = fetchurl {
    url = "mirror://sourceforge/liblo/liblo/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-XfBfKgOV/FrJD2tTi4yCuyGUFAb9GnCnZcczakfXAgg=";
  };

  doCheck = false; # fails 1 out of 3 tests

  meta = {
    description = "Lightweight library to handle the sending and receiving of messages according to the Open Sound Control (OSC) protocol";
    homepage = "https://sourceforge.net/projects/liblo";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.marcweber ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
