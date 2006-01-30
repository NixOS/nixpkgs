{stdenv, fetchurl, python, tcl, readline, file, cpio, beecrypt, unzip, neon, gnupg, libxml2, perl}:

stdenv.mkDerivation {
  name = "rpm-4.4.5";

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/rpm-4.4.5.tar.gz;
    #md5 = "e24ce468082479fe850c9d6563f56db5";
    md5 = "3f277388b0486c6e8ce9b07fdf53993e";
  };
  buildInputs = [python tcl readline file cpio beecrypt unzip neon gnupg libxml2 perl];
  #configureFlags = "--without-python --with-selinux=no --without-lua";
  configureFlags = "--without-python --with-selinux=no";
  patches = [./rpm-4.4.5-lua.patch ./rpm-4.4.5-beecrypt-include.patch ./rpm-4.4.5-neon-include.patch ./rpm-4.4.5-libxml2-include.patch];
  inherit beecrypt neon libxml2;
}
