{ stdenv, fetchurl, bison, flex, autoconf, automake, openssl }:

let

  version = "0.8.8";
  sha256 = "7ca3fb96f5ee6b76eb398d7ea45344ea24855344ced11632241a33353bba05d7";

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
    { file = "bip-0.8.8-configure.patch";
      sha256 = "286e169745e6cd768f0cb95bbc9589ca2bda497eb06461174549b80a459d901c";
    }
    { file = "bip-CVE-2012-0806.patch";
      sha256 = "e47523095ee1d717c762ca0195520026c6ea2c30d8adcf434d276d42f052d506";
    }
    { file = "bip-freenode.patch";
      sha256 = "a67e582f89cc6a32d5bb48c7e8ceb647b889808c2c8798ae3eb27d88869b892f";
    }
  ];

  configureFlags = [ "--disable-pie" ];

  buildInputs = [ bison flex autoconf automake openssl ];

  meta = {
    description = "An IRC proxy (bouncer)";
    homepage = http://bip.milkypond.org/;
    license = stdenv.lib.licenses.gpl2;
  };
}