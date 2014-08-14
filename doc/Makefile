# You may need to override this.
docbookxsl = $(HOME)/.nix-profile/xml/xsl/docbook
dblatex = dblatex

XMLLINT = xmllint --catalogs
XSLTPROC = xsltproc --catalogs \
 --param section.autolabel 1 \
 --param section.label.includes.component.label 1 \
 --param html.stylesheet \'style.css\' \
 --param xref.with.number.and.title 1 \
 --param toc.section.depth 3 \
 --param admon.style \'\' \
 --param callout.graphics.extension \'.gif\'

NEWS_OPTS = \
 --stringparam generate.toc "article nop" \
 --stringparam section.autolabel.max.depth 0 \
 --stringparam header.rule 0

all: NEWS.html NEWS.txt manual.html manual.pdf

NEWS.html: release-notes.xml
	$(XSLTPROC) --nonet --xinclude --output $@ $(NEWS_OPTS) \
	  $(docbookxsl)/xhtml/docbook.xsl release-notes.xml

NEWS.txt: release-notes.xml
	$(XSLTPROC) --nonet --xinclude quote-literals.xsl release-notes.xml | \
	  $(XSLTPROC) --nonet --output $@.tmp.html $(NEWS_OPTS) \
	  $(docbookxsl)/xhtml/docbook.xsl -
	LANG=en_US w3m -dump $@.tmp.html > $@
	rm $@.tmp.html

manual.html: *.xml
	$(XSLTPROC) --nonet --xinclude --output manual.html \
	  $(docbookxsl)/xhtml/docbook.xsl manual.xml

manual.pdf: *.xml
	$(dblatex) \
	  -P doc.collab.show=0 \
	  -P latex.output.revhistory=0 \
	  manual.xml
