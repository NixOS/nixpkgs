addXMLCatalogs () {
    local d i
    # ‘xml/dtd’ and ‘xml/xsl’ are deprecated. Catalogs should be
    # installed underneath ‘share/xml’.
    for d in $1/xml/dtd $1/xml/xsl $1/share/xml; do
        if [ -d $d ]; then
            for i in $(find $d -name catalog.xml); do
                XML_CATALOG_FILES="$i $XML_CATALOG_FILES"
            done
        fi
    done
}

if [ -z "$libxmlHookDone" ]; then
    libxmlHookDone=1

    # Set up XML_CATALOG_FILES.  An empty initial value prevents
    # xmllint and xsltproc from looking in /etc/xml/catalog.
    export XML_CATALOG_FILES
    if [ -z "$XML_CATALOG_FILES" ]; then XML_CATALOG_FILES=" "; fi
    envHooks+=(addXMLCatalogs)
fi
