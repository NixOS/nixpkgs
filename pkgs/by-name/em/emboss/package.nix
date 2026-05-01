{
  lib,
  stdenv,
  fetchurl,
  readline,
  perl,
  libharu,
  libx11,
  libpng,
  libxt,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "emboss";
  version = "6.6.0";

  src = fetchurl {
    url = "ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-${finalAttrs.version}.tar.gz";
    sha256 = "7184a763d39ad96bb598bfd531628a34aa53e474db9e7cac4416c2a40ab10c6e";
  };

  buildInputs = [
    readline
    perl
    libharu
    libpng
    libx11
    libxt
    zlib
  ];

  configureFlags = [
    "--with-hpdf=${libharu}"
    "--with-pngdriver=${zlib}"
  ];

  postConfigure = ''
    sed -i 's@$(bindir)/embossupdate@true@' Makefile
  '';

  meta = {
    description = "European Molecular Biology Open Software Suite";
    longDescription = ''
      EMBOSS is a free Open Source software analysis package
      specially developed for the needs of the molecular biology (e.g. EMBnet)
      user community, including libraries. The software automatically copes with
      data in a variety of formats and even allows transparent retrieval of
      sequence data from the web.
    '';
    license = lib.licenses.gpl2;
    homepage = "https://emboss.sourceforge.net/";
    # The last successful Darwin Hydra build was in 2024
    broken = stdenv.hostPlatform.isDarwin;
  };
})
