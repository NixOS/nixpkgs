{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bibclean";
  version = "3.07";

  src = fetchurl {
    url = "http://ftp.math.utah.edu/pub/bibclean/bibclean-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-kZM2eC6ePCBOYPVkhf0fjdZ562IvyP0fSDNZXuEBkaY=";
  };

  postPatch = ''
    substituteInPlace Makefile.in --replace man/man1 share/man/man1
  '';

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

  meta = {
    description = "Prettyprint and syntax check BibTeX and Scribe bibliography data base files";
    homepage = "http://ftp.math.utah.edu/pub/bibclean";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
