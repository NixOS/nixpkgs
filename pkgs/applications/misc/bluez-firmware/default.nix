{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "bluez-firmware-1.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/bluez-firmware-1.1.tar.gz;
    md5 = "2f1c2d939108c865dd07bae3e819c573";
  };
}
