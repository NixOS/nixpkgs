{ fetchurl, fetchpatch, lib, stdenv, ncurses, gnupg }:

let version = "0.7.4";
in stdenv.mkDerivation {
  # mdp renamed to gpg-mdp because there is a mdp package already.
  pname = "gpg-mdp";
  inherit version;
  meta = {
    homepage = "https://tamentis.com/projects/mdp/";
    license = [lib.licenses.isc];
    description = "Manage your passwords with GnuPG and a text editor";
  };
  src = fetchurl {
    url = "https://tamentis.com/projects/mdp/files/mdp-${version}.tar.gz";
    sha256 = "04mdnx4ccpxf9m2myy9nvpl9ma4jgzmv9bkrzv2b9affzss3r34g";
  };
  patches = [
    # Pull fix pending upstream inclusion for -fno-common toolchain support:
    #   https://github.com/tamentis/mdp/pull/9
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/tamentis/mdp/commit/95c77de3beb96dc7c76ff36d3f3dfb18411d7c54.patch";
      sha256 = "1j6yvjzkx31b758yav4arhlm5ig7phl8mgx4fcwj7lm2pfvzwcsz";
    })
  ];
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
