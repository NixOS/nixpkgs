{ stdenv, fetchurl, git, asciidoc, xmlto, docbook_xsl, docbook_xml_dtd_45, libxslt }:

stdenv.mkDerivation {
  name = "git-subtree-0.4-2-g2793ee6";

  src = fetchurl {
    url = "http://github.com/apenwarr/git-subtree/tarball/2793ee6ba6da57d97e9c313741041f7eb2e88974";
    sha256 = "33fdba315cf8846f45dff7622c1099c386db960c7b43d5d8fbb382fd4d1acff6";
    name = "git-subtree-0.4-2-g2793ee6.tar.gz";
  };

  buildInputs = [ git asciidoc xmlto docbook_xsl docbook_xml_dtd_45 libxslt ];

  configurePhase = "export prefix=$out";

  buildPhase = "true";

  installPhase = "make install prefix=$out gitdir=$out/bin";

  meta= {
    description = "experimental alternative to the git-submodule command";
    homepage = http://github.com/apenwarr/git-subtree;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.gnu;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
