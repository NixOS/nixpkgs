with import ./.. { };
with lib;

stdenv.mkDerivation {
  name = "nixpkgs-manual";

  sources = sourceFilesBySuffices ./. [".xml"];

  buildInputs = [ libxml2 libxslt ];

  xsltFlags = ''
    --param section.autolabel 1
    --param section.label.includes.component.label 1
    --param html.stylesheet 'style.css'
    --param xref.with.number.and.title 1
    --param toc.section.depth 3
    --param admon.style '''
    --param callout.graphics.extension '.gif'
  '';

  buildCommand = ''
    ln -s $sources/*.xml . # */

    echo ${nixpkgsVersion} > .version

    xmllint --noout --nonet --xinclude --noxincludenode \
      --relaxng ${docbook5}/xml/rng/docbook/docbook.rng \
      manual.xml

    dst=$out/share/doc/nixpkgs
    mkdir -p $dst
    xsltproc $xsltFlags --nonet --xinclude \
      --output $dst/manual.html \
      ${docbook5_xsl}/xml/xsl/docbook/xhtml/docbook.xsl \
      ./manual.xml

    cp ${./style.css} $dst/style.css

    mkdir -p $out/nix-support
    echo "doc manual $dst manual.html" >> $out/nix-support/hydra-build-products
  '';
}
