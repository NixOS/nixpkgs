{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bibtool";
  version = "2.68";

  src = fetchurl {
    url = "http://www.gerd-neugebauer.de/software/TeX/BibTool/BibTool-${finalAttrs.version}.tar.gz";
    sha256 = "1ymq901ckaysq2n1bplk1064rb2njq9n30pii15w157y0lxcwd3i";
  };

  # Perl for running test suite.
  buildInputs = [ perl ];

  installTargets = [
    "install"
    "install.man"
  ];

  doCheck = true;
  checkTarget = "test";

  meta = {
    description = "Tool for manipulating BibTeX bibliographies";
    homepage = "http://www.gerd-neugebauer.de/software/TeX/BibTool/index.en.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.rycee ];
    mainProgram = "bibtool";
  };
})
