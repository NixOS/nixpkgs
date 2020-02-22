{ stdenv, fetchurl, fetchpatch, bison, flex, autoconf, automake, openssl }:

stdenv.mkDerivation rec {
  pname = "bip";
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
    (fetchpatch {
      url = "https://projects.duckcorp.org/projects/bip/repository/bip/revisions/87192685f55856d2c28021963ab2c308e21faddc/diff?format=diff";
      sha256 = "0rspzp7q1lq8v0cl0c35xxpgisfk264i648vslgsjax2s0g9svx0";
    })
    (fetchpatch {
      url = "https://projects.duckcorp.org/projects/bip/repository/bip/revisions/814d54c676d5827f6ea37c1cd2d6e846d080c13c/diff?format=diff";
      sha256 = "137l77kmm6p9p4c4kvw2zc4xkr10ayyc9z5rlpwn67574h47v55i";
    })
    (fetchpatch {
      url = "https://projects.duckcorp.org/projects/bip/repository/bip/revisions/d2dcb0adb1aa8c2c4526aa6ad650483b0e02ab7d/diff?format=diff";
      sha256 = "1pvywaljdkmy4870xs6gvsk4qwg69h47qr0yjywbcdsfycrgp8aq";
    })
  ];

  NIX_CFLAGS_COMPILE = "-Wno-error=unused-result -Wno-error=duplicate-decl-specifier";

  meta = {
    description = "An IRC proxy (bouncer)";
    homepage = http://bip.milkypond.org/;
    license = stdenv.lib.licenses.gpl2;
    downloadPage = "https://projects.duckcorp.org/projects/bip/files";
    platforms = stdenv.lib.platforms.linux;
  };
}
