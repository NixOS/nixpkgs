{
  lib,
  stdenv,
  fetchurl,
  libtiff,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "minidjvu";
  version = "0.8";

  src = fetchurl {
    url = "mirror://sourceforge/minidjvu/minidjvu-${version}.tar.gz";
    sha256 = "0jmpvy4g68k6xgplj9zsl6brg6vi81mx3nx2x9hfbr1f4zh95j79";
  };

  patchPhase = ''
    sed -i s,/usr/bin/gzip,gzip, Makefile.in
  '';

  buildInputs = [
    libtiff
    gettext
  ];

  preInstall = ''
    mkdir -p $out/lib
  '';

  meta = {
    homepage = "https://djvu.sourceforge.net/djview4.html";
    description = "Black-and-white djvu page encoder and decoder that use interpage information";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "minidjvu";
    knownVulnerabilities = [
      "minidjvu is vulnerable to a number of out-of-bound read vulnerabilities, potentially causing denials of service (CVE-2017-12441, CVE-2017-12442, CVE-2017-12443, CVE-2017-12444, CVE-2017-12445)"
    ];
  };
}
