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

all: manual.html manual.pdf

manual.html: *.xml options-db.xml version
	$(XSLTPROC) --nonet --xinclude --output manual.html \
	  $(docbookxsl)/xhtml/docbook.xsl manual.xml

manual.pdf: *.xml options-db.xml version
	$(dblatex) \
	  -P doc.collab.show=0 \
	  -P latex.output.revhistory=0 \
	  manual.xml

options-db.xml:
	echo '<refentry xmlns="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xi="http://www.w3.org/2001/XInclude"></refentry>' > options-db.xml

version:
	echo 'Local Snapshot' > version
