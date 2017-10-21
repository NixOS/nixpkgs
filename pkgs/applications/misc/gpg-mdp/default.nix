{ fetchurl, stdenv, ncurses, gnupg }:

let version = "0.7.4";
in stdenv.mkDerivation {
  # mdp renamed to gpg-mdp because there is a mdp package already.
  name = "gpg-mdp-${version}";
  meta = {
    homepage = https://tamentis.com/projects/mdp/;
    license = [stdenv.lib.licenses.isc];
    description = "Manage your passwords with GnuPG and a text editor";
  };
  src = fetchurl {
    url = "https://tamentis.com/projects/mdp/files/mdp-${version}.tar.gz";
    sha256 = "04mdnx4ccpxf9m2myy9nvpl9ma4jgzmv9bkrzv2b9affzss3r34g";
  };
  buildInputs = [ ncurses ];
  prePatch = ''
    substituteInPlace ./configure \
      --replace "alias echo=/bin/echo" ""

    substituteInPlace ./src/config.c \
      --replace "/usr/bin/gpg" "${gnupg}/bin/gpg" \
      --replace "/usr/bin/vi" "vi"

    substituteInPlace ./mdp.1 \
      --replace "/usr/bin/gpg" "${gnupg}/bin/gpg"
  '';
  # we add symlinks to the binary and man page with the name 'gpg-mdp', in case
  # the completely unrelated program also named 'mdp' is already installed.
  postFixup = ''
    ln -s $out/bin/mdp $out/bin/gpg-mdp
    ln -s $out/share/man/man1/mdp.1.gz $out/share/man/man1/gpg-mdp.1.gz
  '';
}
