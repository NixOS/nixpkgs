XMLLINT = xmllint --catalogs
XSLTPROC = xsltproc --catalogs \
 --param section.autolabel 1 \
 --param section.label.includes.component.label 1 \
 --param html.stylesheet \'style.css\' \
 --param xref.with.number.and.title 1 \
 --param toc.section.depth 3 \
 --param admon.style \'\' \
 --param callout.graphics.extension \'.gif\'

docbookxsl = $(HOME)/.nix-profile/xml/xsl/docbook

manual.html: manual.xml options-db.xml
	$(XSLTPROC) --nonet --xinclude --output $@ \
	  $(docbookxsl)/html/docbook.xsl manual.xml

options-db.xml: options.xml options-to-docbook.xsl
	xsltproc -o options-db.xml options-to-docbook.xsl options.xml 

options.xml: ../../system/options.nix
	echo 'import ../../system/options.nix {pkgs = import ../../pkgs/top-level/all-packages.nix {};}' | \
	    nix-instantiate --eval-only --xml --strict - > options.xml || (rm options.xml && false)
