{stdenv, fetchurl, bluezLibs}:

stdenv.mkDerivation {
  name = "bluez-utils-2.25";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/bluez-utils-2.25.tar.gz;
    md5 = "ae3729ab5592be06ed01b973d4b3e9fe";
  };
  buildInputs = [bluezLibs];
}
