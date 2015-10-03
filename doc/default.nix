with import ./.. { };
with lib;

stdenv.mkDerivation {
  name = "nixpkgs-manual";

  sources = sourceFilesBySuffices ./. [".xml"];

  buildInputs = [ pandoc libxml2 libxslt ];

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
    {
      echo "<chapter xmlns=\"http://docbook.org/ns/docbook\""
      echo "         xmlns:xlink=\"http://www.w3.org/1999/xlink\""
      echo "         xml:id=\"users-guide-to-the-haskell-infrastructure\">"
      echo ""
      echo "<title>User's Guide to the Haskell Infrastructure</title>"
      echo ""
      pandoc ${./haskell-users-guide.md} -w docbook | \
        sed -e 's|<ulink url=|<link xlink:href=|' \
            -e 's|</ulink>|</link>|' \
            -e 's|<sect. id=|<section xml:id=|' \
            -e 's|</sect[0-9]>|</section>|'
      echo ""
      echo "</chapter>"
    } >haskell-users-guide.xml

    ln -s "$sources/"*.xml .

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

    mkdir -p $dst/images/callouts
    cp "${docbook5_xsl}/xml/xsl/docbook/images/callouts/"*.gif $dst/images/callouts/

    mkdir -p $out/nix-support
    echo "doc manual $dst manual.html" >> $out/nix-support/hydra-build-products
  '';
}
