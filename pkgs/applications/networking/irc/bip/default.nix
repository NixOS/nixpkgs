{ stdenv, fetchurl, fetchpatch, bison, flex, autoconf, automake, openssl }:

stdenv.mkDerivation rec {
  name = "bip-${version}";
  version = "0.8.9";

  # fetch sources from debian, because the creator's website provides
  # the files only via https but with an untrusted certificate.
  src = fetchurl {
    url = "mirror://debian/pool/main/b/bip/bip_${version}.orig.tar.gz";
    sha256 = "0q942g9lyd8pjvqimv547n6vik5759r9npw3ws3bdj4ixxqhz59w";
  };

  buildInputs = [ bison flex autoconf automake openssl ];

  # includes an important security patch
  patches = [
    (fetchpatch {
      url = "mirror://gentoo/../gentoo-portage/net-irc/bip/files/bip-freenode.patch";
      sha256 = "05qy7a62p16f5knrsdv2lkhc07al18qq32ciq3k4r0lq1wbahj2y";
    })
    (fetchpatch {
      url = "https://projects.duckcorp.org/projects/bip/repository/revisions/39414f8ff9df63c8bc2e4eee34f09f829a5bf8f5/diff/src/connection.c?format=diff";
      sha256 = "1hvg58vci6invh0z19wf04jjvnm8w6f6v4c4nk1j5hc3ymxdp1rb";
    })
  ];

  NIX_CFLAGS_COMPILE = "-Wno-error=unused-result";

  meta = {
    description = "An IRC proxy (bouncer)";
    homepage = http://bip.milkypond.org/;
    license = stdenv.lib.licenses.gpl2;
    downloadPage = "https://projects.duckcorp.org/projects/bip/files";
    platforms = stdenv.lib.platforms.linux;
  };
}
