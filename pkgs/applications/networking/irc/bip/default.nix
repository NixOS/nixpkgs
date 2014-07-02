{ stdenv, fetchurl, bison, flex, autoconf, automake, openssl }:

let

  version = "0.8.9";
  sha256 = "0q942g9lyd8pjvqimv547n6vik5759r9npw3ws3bdj4ixxqhz59w";

  # fetches patches from a gentoo mirror
  fetchPatch =
    { file, sha256 }:
    fetchurl {
      url = "mirror://gentoo/../gentoo-portage/net-irc/bip/files/${file}";
      inherit sha256;
    };

in stdenv.mkDerivation {
  name = "bip-${version}";

  # fetch sources from debian, because the creator's website provides
  # the files only via https but with an untrusted certificate.
  src = fetchurl {
    url = "mirror://debian/pool/main/b/bip/bip_${version}.orig.tar.gz";
    inherit sha256;
  };

  # includes an important security patch
  patches = map fetchPatch [
    { file = "bip-freenode.patch";
      sha256 = "a67e582f89cc6a32d5bb48c7e8ceb647b889808c2c8798ae3eb27d88869b892f";
    }
  ];

  postPatch = ''
  '';

  configureFlags = [ "--disable-pie" ];

  buildInputs = [ bison flex autoconf automake openssl ];

  meta = {
    description = "An IRC proxy (bouncer)";
    homepage = http://bip.milkypond.org/;
    license = stdenv.lib.licenses.gpl2;
    downloadPage= "https://projects.duckcorp.org/projects/bip/files";
    inherit version;
  };
}
